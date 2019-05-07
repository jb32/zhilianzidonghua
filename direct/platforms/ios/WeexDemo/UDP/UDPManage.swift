//
//  UDPManage.swift
//  Inteligence
//
//  Created by zzzl on 2018/10/8.
//  Copyright © 2018年 zzzl. All rights reserved.
//

import Foundation
import AVFoundation
import AdSupport
import SwiftyJSON
import Reachability

class UDPManage: NSObject {
    typealias Rsp = ([String: Any]) -> Void
    
    private var uuid: String
    private let networdReachability = Reachability(hostname: .host)
    
    private var soundID = SystemSoundID(10000)
    private var isPlaySound = false
    private var bgTaskId: UIBackgroundTaskIdentifier?
    
    private var scoket: GCDAsyncUdpSocket?
    private var queue = UDPQueue()
    
    static var share = UDPManage()
    weak var viewController: BaseViewController? {
        didSet {
            guard let vc = viewController else { return }
            queue.queue = vc.commandQueue
        }
    }
    
    override init() {
        uuid = .uuid
        Config.sound(&soundID)
        
        super.init()
        
        try? networdReachability?.startNotifier()
        networdReachability?.whenReachable = { reachability in
            switch reachability.connection {
            case .wifi, .cellular:
                NotificationCenter.default.post(name: .refreshInstance, object: nil)
            case .none:
                let alertVC = UIAlertController(title: nil, message: "连接网络失败", preferredStyle: .alert)
                let confim = UIAlertAction(title: "确定", style: .default, handler: nil)
                alertVC.addAction(confim)
                UIApplication.shared.keyWindow?.rootViewController?.present(alertVC, animated: true, completion: nil)
            }
        }
        networdReachability?.whenUnreachable = { _ in
            let alertVC = UIAlertController(title: nil, message: "连接网络失败", preferredStyle: .alert)
            let confim = UIAlertAction(title: "确定", style: .default, handler: nil)
            alertVC.addAction(confim)
            UIApplication.shared.keyWindow?.rootViewController?.present(alertVC, animated: true, completion: nil)
        }
        queue.manage = self
    }
    
    deinit {
        scoket?.close()
        networdReachability?.stopNotifier()
    }
    
    func create() -> Void {
        scoket = GCDAsyncUdpSocket(delegate: self, delegateQueue: DispatchQueue.main)
        
        do {
            try scoket?.bind(toPort: UInt16.random(in: 50000..<UInt16.max))
            try scoket?.beginReceiving()
            try scoket?.enableBroadcast(true)
//            scoket?.send("aaa".data(using: .utf8)!, toHost: "255.255.255.255", port: 60000, withTimeout: 2, tag: 1)
        } catch {
            print(error.localizedDescription)
        }
    }
}

// MARK: - send
extension UDPManage {
    /// 命令入口
    ///
    /// - Parameters:
    ///   - order: 命令类型
    ///   - param: 命令参数
    ///   - call: 命令响应接收
    func perform(order: Order, param: [String: AnyHashable]?, call: @escaping WXKeepAliveCallback, isInterrupt: Bool = false) -> Void {
        queue.perform(order: order, uuid: uuid, param: param, callback: call, isInterrupt: isInterrupt)
    }
    
    func interruptAll() -> Void {
        queue.interrupt()
    }
    
    func sendCommand(with data: Data, tag: Int, host: String = .host, port: UInt16 = .port) -> Void {
        scoket?.send(data, toHost: host, port: port, withTimeout: -1, tag: tag)
    }
}

extension UDPManage: GCDAsyncUdpSocketDelegate {
    func udpSocket(_ sock: GCDAsyncUdpSocket, didSendDataWithTag tag: Int) {
//        print(msg: String.localhosts)
    }
    
    func udpSocket(_ sock: GCDAsyncUdpSocket, didNotSendDataWithTag tag: Int, dueToError error: Error?) {
        
    }
    
    func udpSocket(_ sock: GCDAsyncUdpSocket, didReceive data: Data, fromAddress address: Data, withFilterContext filterContext: Any?) {
        
        guard let from = GCDAsyncUdpSocket.host(fromAddress: address) else { return }
        queue.recive(data: data, from: from)
    }
}

extension UDPManage {
    
    func alarm(msg: String) -> Void {
        if !self.isPlaySound {
            self.isPlaySound = true
            DispatchQueue.main.async {
                DispatchQueue.main.asyncAfter(deadline: .now() + 60, execute: {
                    self.isPlaySound = false
                })
                Config.playSound(self.soundID, isFinish: { _ in
//                    self.isPlaySound = !$0
                })
                Config.pushLocalNotify(msg)
            }
        }
    }
}

//MARK: - background

extension UDPManage {
    
    func beginBackgroundTask() -> Void {
        bgTaskId = UIApplication.shared.beginBackgroundTask(expirationHandler: { [weak self] in
            self?.beginBackgroundTask()
        })
    }
    
    func endBackgroundTask() -> Void {
        if let bgTaskId = bgTaskId {
            UIApplication.shared.endBackgroundTask(bgTaskId)
        }
    }
}

