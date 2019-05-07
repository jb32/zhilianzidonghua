//
//  UDPCommand.swift
//  WeexDemo
//
//  Created by zzzl on 2019/2/14.
//  Copyright © 2019 zzzl. All rights reserved.
//

import Foundation
import SwiftyJSON

class UDPCommand {
    var order: Order
    var param: Param
    var priority: Priority
    
    var callback: WXKeepAliveCallback
    var resend: ((UDPCommand) -> Void)?
    var completion: (() -> Void)?
    
    var createDate = Date()
    private(set) var state: State = .none
    var counter: UInt = 0
    var response: [String: Any]?
    
    private var timer: DispatchSourceTimer?
    
    var isService: Bool {
        return order.isService()
    }
    
    init(order: Order, param: Param, priority: Priority, queue: DispatchQueue, callback: @escaping WXKeepAliveCallback) {
        self.order = order
        self.param = param
        self.callback = callback
        self.priority = priority
        self.timer = DispatchSource.makeTimerSource(queue: queue)
        self.timer?.schedule(deadline: .now() + 1, repeating: .seconds(1))
        self.timer?.setEventHandler { [weak self] in
            guard let `self` = self else { return }
            print(msg: "…………………………………………重发：\(order.sub)")
            self.state = .resend
            self.timer?.suspend()
            self.resend?(self)
        }
    }
    
    deinit {
        print(msg: "^^^^^^^^^^^\(state)^^^^^^^^\(order.sub) 释放了....\(Unmanaged.passUnretained(self).toOpaque())")
        if state != .send {
            timer?.resume()
        }
        timer?.cancel()
        timer = nil
    }
    
    func start() -> Void {
        print(msg: "…………重发机制开启…\(state)……………\(self.order.sub)....\(Unmanaged.passUnretained(self).toOpaque())")
        
        if state != .send {
            state = .send
            timer?.resume()
        }
    }
    
    func stop() -> Void {
        print(msg: "…………关闭重发机制……\(state)…………\(order.sub)....\(Unmanaged.passUnretained(self).toOpaque())")
        
        if state == .send {
            state = .stop
            timer?.suspend()
        }
    }
    
    func finish() -> Void {
        print(msg: "…………完成命令………\(state)………\(order.sub)....\(Unmanaged.passUnretained(self).toOpaque())")
        
        if state == .send {
            state = .finish
            timer?.suspend()
        }
        completion?()
    }
}

extension UDPCommand: Equatable {
    static func ==(lhs: UDPCommand, rhs: UDPCommand) -> Bool {
        return lhs.order == rhs.order && lhs.param == rhs.param
    }
}

extension UDPCommand {
    struct Param: Equatable {
        var token: String?
        var uuid: String
        var param: JSON
        var mid: String? {
            return param["mid"].string
        }
        init(uuid: String, token: String? = nil, param: [String: AnyHashable]) {
            self.uuid = uuid
            self.token = token
            let p = param.filter { (item) -> Bool in
                return item.key != "token"
            }
            self.param = JSON(p)
        }
        
        static func == (lhs: UDPCommand.Param, rhs: UDPCommand.Param) -> Bool {
            return lhs.token == rhs.token && lhs.param == rhs.param
        }
    }
}

extension UDPCommand {
    enum Priority: Int {
        case low = 1, middle, hight
    }
}



extension UDPCommand.Priority: Comparable {
    static func < (lhs: UDPCommand.Priority, rhs: UDPCommand.Priority) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }
}

extension UDPCommand {
    /// 命令状态
    ///
    /// - none: 无状态，初始化状态
    /// - send: 发送状态
    /// - resend: 重发状态
    /// - stop: 停止状态
    /// - finish: 完成状态
    enum State: Int {
        case none = 0, send, resend, stop, finish
    }
}
