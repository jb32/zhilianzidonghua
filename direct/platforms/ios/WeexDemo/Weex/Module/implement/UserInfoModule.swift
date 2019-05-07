//
//  NavigatorUtil.swift
//  Inteligence
//
//  Created by zzzl on 2018/10/30.
//  Copyright © 2018 zzzl. All rights reserved.
//

import Foundation

extension UserInfoModule {
    @objc func getParam(_ callback: @escaping WXModuleKeepAliveCallback) -> Void {
        let bvc = weexInstance.viewController as? BaseViewController
        let dic = bvc?.param ?? [:]
        callback(dic, false)
    }
    
    @objc func setParam(with other: [String: AnyHashable]) -> Void {
        let bvc = weexInstance.viewController as! BaseViewController
        bvc.param.merge(other) { (_, new) -> AnyHashable in
            return new
        }
    }
}
