//
//  RspStatus.swift
//  WeexDemo
//
//  Created by zzzl on 2019/1/7.
//  Copyright © 2019 zzzl. All rights reserved.
//

import Foundation

enum RspStatus: UInt8 {
    case success = 0
    case nonsupport = 1
    case setting = 2
    case psdError = 3
    case orderError = 4
    case otherError = 15
}

extension RspStatus {
    func des() -> String {
        switch self {
        case .nonsupport:   return "分机不支持此命令"
        case .orderError:   return "命令数据错误"
        case .otherError:   return "其他错误"
        case .psdError:     return "密码错误"
        case .setting:      return "分机处于设定操作状态，不能对分机进行控制"
        case .success:      return "命令已成功执行"
        }
    }
}
