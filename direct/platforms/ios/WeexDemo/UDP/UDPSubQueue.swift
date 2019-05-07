//
//  UDPSubQueue.swift
//  WeexDemo
//
//  Created by zzzl on 2019/3/6.
//  Copyright © 2019 zzzl. All rights reserved.
//

import Foundation

class UDPSubQueue {
    private var queue: DispatchQueue
    private var current: UDPCommand!
    private var isInterrupt = false
        
    init(label: String) {
        queue = DispatchQueue(label: label)
    }
    /// 创建命令
    ///
    /// - Parameters:
    ///   - param: 命令参数
    ///   - complete: 命令创建完成
    fileprivate func createCommand(_ param: UDPQueue.OrderParam, complete: @escaping (Data) -> Void) {
        let cmd_param = UDPCommand.Param(uuid: param.uuid, token: param.token, param: param.param)
        self.current = UDPCommand(order: param.order, param: cmd_param
            , priority: param.priority, queue: self.queue, callback: param.call)
        print(msg: "建立命令\(self.current.order)")
        self.current.resend = { [unowned self] (cmd) in
            if self.current.order != cmd.order {
                return
            }
            if !self.isInterrupt {
                complete(self.deal())
            }
        }
        self.current.completion = {}
        
        if !self.isInterrupt {
            complete(self.deal())
        }
    }
    /// 处理命令，获取发送数据
    ///
    /// - Parameters:
    ///   - param: 命令参数
    ///   - complete: 命令创建完成
    func deal(_ param: UDPQueue.OrderParam, complete: @escaping (Data) -> Void) -> Void {
        queue.async {
            guard let current = self.current else {
                self.createCommand(param, complete: complete)
                return
            }
            
            if current.state == .finish {
                Thread.sleep(forTimeInterval: 1)
                self.createCommand(param, complete: complete)
            } else {
                if current.priority >= .middle && current.state != .stop {
                    return
                }
                self.createCommand(param, complete: complete)
            }
        }
    }
    /// 开启计时重发机制，并发送命令
    ///
    /// - Returns: 命令内容
    private func deal() -> Data {
        current.start()
        let content = UDPHandle(command: current).encode()
        print(msg: "------------------send \(current.order.sub)------------------")
        return content
    }
    /// 中断命令
    ///
    /// - Parameter order: 命令
    func interrupt(order: Order? = nil) {
        if let order = order {
            if current?.order == order {
                current?.stop()
                isInterrupt = true
            }
        } else {
            current?.stop()
            isInterrupt = true
        }
    }
    /// 重启命令
    func resume() -> Void {
        isInterrupt = false
    }
    /// 收到响应，校验响应
    ///
    /// - Parameters:
    ///   - handle: 响应解析器
    ///   - alarm: 警报字段
    func check(_ handle: UDPHandle, alarm: @escaping (String) -> Void) -> Void {
        queue.async {
            if let rsp = handle.getRsp(), self.current.order == handle.order {
                if self.current.state == .finish {
                    return;
                }
                if let mid = self.current.param.mid, let handle_mid = handle.mid, mid != handle_mid {
                    return;
                }
                self.current.finish()
                print(msg: "==================\(self.current.order.sub)====================")
                if handle.isAlarm {
                    alarm("\(handle.mid!):" + handle.alarmDes)
                }
                self.current.callback(rsp, false)
            }
        }
    }
}
