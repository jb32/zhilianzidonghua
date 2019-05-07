//
//  DeviceType.swift
//  WeexDemo
//
//  Created by zzzl on 2019/2/14.
//  Copyright © 2019 zzzl. All rights reserved.
//

import Foundation

struct DeviceType {
    let rawValue: UInt32
    
    init(rawValue: UInt32) {
        self.rawValue = rawValue
    }
    
    /// 改进代码
    private var improve: String {
        let num = UInt8(truncatingIfNeeded: rawValue & 0xF)
        return String(num)
    }
    /// 细分类型
    private var subdivide: String {
        let num = UInt8(truncatingIfNeeded: (rawValue >> 4) & 0xF)
        return num.xvHao
    }
    /// 显示方式
    private var display: String {
        let num = UInt8(truncatingIfNeeded: (rawValue >> 8) & 0x3F)
        return num.roman
    }
    /// 控制器类型
    private var controller: String {
        let num = UInt8(truncatingIfNeeded: (rawValue >> 14) & 0x3F)
        let ct = Controller(rawValue: num)
        return ct?.name ?? ""
    }
    /// 烤房控制器代号
    private var mark: String {
        let num = UInt8(truncatingIfNeeded: (rawValue >> 24) & 0xFF)
        let mk = Mark(rawValue: num)
        return mk?.name ?? ""
    }
    
    var arr: [String] {
        return [mark, controller, "-", display, subdivide, "/", improve]
    }
}


extension DeviceType {
    enum Controller: UInt8 {
        case m = 1, s, d
    }
}

extension DeviceType.Controller {
    var name: String {
        switch self {
        case .d:
            return "D"
        case .m:
            return "M"
        case .s:
            return "S"
        }
    }
}

extension DeviceType {
    enum Mark: UInt8 {
        case jk = 1
    }
}

extension DeviceType.Mark {
    var name: String {
        switch self {
        case .jk:
            return "JK"
        }
    }
}
