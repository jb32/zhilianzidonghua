//
//  UDPHandle.swift
//  Inteligence
//
//  Created by zzzl on 2018/10/9.
//  Copyright © 2018年 zzzl. All rights reserved.
//

import Foundation
import Gzip
import CryptoSwift

extension UDP {
    
    @objc func send(_ cmd: Int, param: [String: AnyHashable], callback: @escaping WXModuleKeepAliveCallback) {
        guard let order = Order(rawValue: UInt8(truncatingIfNeeded: cmd)) else { callback([:], false); return }
        
        print(msg: "\(order) send")
        UDPManage.share.viewController = weexInstance.viewController as? BaseViewController
        UDPManage.share.perform(order: order, param: param, call: callback)
    }
    
    @objc func interrupt(_ cmd: Int) {
        guard let order = Order(rawValue: UInt8(truncatingIfNeeded: cmd)) else { return }
        print(msg: "\(order) interrupt")
        
        UDPManage.share.viewController = weexInstance?.viewController as? BaseViewController
        UDPManage.share.perform(order: order, param: nil, call: { (_, _) in }, isInterrupt: true)
    }
    
    @objc func interruptAll() {
        UDPManage.share.viewController = weexInstance.viewController as? BaseViewController
        UDPManage.share.interruptAll()
    }
}
