//
//  UDPQueue.swift
//  WeexDemo
//
//  Created by zzzl on 2018/11/12.
//  Copyright © 2018 zzzl. All rights reserved.
//

import UIKit
import SwiftyJSON

class UDPQueue {
    
    weak var queue: UDPSubQueue?
    weak var manage: UDPManage?
    
    init() {}
    
    func perform(order: Order,
                 uuid: String,
                 param: [String: AnyHashable]?,
                 callback: @escaping WXKeepAliveCallback,
                 isInterrupt: Bool) -> Void {
        if !isInterrupt, let param = param {
            let orderParam = OrderParam(order: order, uuid: uuid, param: param, call: callback)
            queue?.deal(orderParam) { (content) in
                self.manage?.sendCommand(with: content, tag: 100 + Int(order.rawValue))
            }
        } else {
            interrupt(order: order)
        }
    }
    func interrupt(order: Order? = nil) -> Void {
        queue?.interrupt(order: order)
    }

    func recive(data: Data, from: String) -> Void {
        guard let handle = UDPHandle(service: data) else {
            return
        }
        
        queue?.check(handle, alarm: { (msg) in
            self.manage?.alarm(msg: msg)
        })
    }
}

extension UDPQueue {
    struct OrderParam {
        let order: Order
        let uuid: String
        let token: String?
        let param: [String: AnyHashable]
        let call: WXKeepAliveCallback
        let priority: UDPCommand.Priority
        
        init(order: Order,
             uuid: String,
             param: [String: AnyHashable],
             call: @escaping WXKeepAliveCallback) {
            self.order = order
            self.uuid = uuid
            
            var priority: UDPCommand.Priority = .middle
            var _param = param
            
            if let rawValue = _param["priority"] as? Int {
                priority = UDPCommand.Priority(rawValue: rawValue) ?? .middle
                _param.removeValue(forKey: "priority")
            }
            let token = _param["token"] as? String
            
            if token != nil {
                _param.removeValue(forKey: "token")
            }
            self.token = token
            self.param = _param
            self.call = call
            self.priority = priority
        }
    }
}


