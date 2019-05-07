//
//  Command.swift
//  Inteligence
//
//  Created by zzzl on 2018/10/9.
//  Copyright © 2018年 zzzl. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Order {
    let sub: SubOrder
    let rw: RW
    let rawValue: UInt8
    
    init(sub: SubOrder, rw: RW) {
        self.sub = sub
        self.rw = rw
        
        if self.sub.rawValue >= 0xF7 {
            self.rawValue = sub.rawValue
        } else {
            self.rawValue = sub.rawValue | rw.rawValue
        }
    }
    
    init?(rawValue: UInt8) {
        self.rawValue = rawValue
        
        if rawValue >= 0xF7 {
            guard let sub = SubOrder(rawValue: rawValue) else { return nil }
            self.sub = sub
            rw = .read
        } else {
            guard let sub = SubOrder(rawValue: rawValue & 0x1F) else { return nil }
            guard let rw = RW(rawValue: rawValue & 0x40) else { return nil }
            self.sub = sub
            self.rw = rw
        }
    }
    
    func isService() -> Bool {
        return rawValue >= SubOrder.bindDevice.rawValue
    }
}

extension Order: Equatable {
    public static func == (lhs: Order, rhs: Order) -> Bool {
        return lhs.rawValue == rhs.rawValue
    }
}

extension Order: Comparable {
    static func < (lhs: Order, rhs: Order) -> Bool {
        return lhs.sub < rhs.sub
    }
}

enum SubOrder: UInt8, Codable {
    /// 5A 4C 57 58 31 38 30 37 32 32 30 30 30 33 0D 0A
    /// 00 00 1E 00 0E 5A 4C 57 58 31 38 30 37 32 32 30 30 30 33 00 00 08 11 82 00 01 00 01 01 02 60 88
    /// 命令码=0x00(R),读取分机设备类型、协议版本、软件版本 00 00 05 40 00 01 00 02 B8
    case status                                     = 0x0
    /// 01 00 1E 00 0E 5A 4C 57 58 31 38 30 37 32 32 30 30 30 33 01 00 1C 0A 62 3A 07 40 07 00 00 02 00 72 10 D8 0E E7 00 06 03 27 07 3A 07 2C 26 05 01 00 00 CE 87
    /// 命令码=0x01(R),读取分机实时数据
    case realTime                                   = 0x1
    /// 命令码=0x02(RW),读写分机整条曲线数据
    case curves                                     = 0x2
    /// 命令码=0x03(RW),读写分机曲线段数据
    case curve                                      = 0x3
    /// 命令码=0x04(W),分机运行/停止控制
    case run                                        = 0x4
    /// 命令码=0x05(W),选择分机烘烤曲线
    case curveCoding                                = 0x5
    /// 命令码=0x06(W),设置分机运行段
    case curveNum                                   = 0x6
    /// 命令码=0x07(W),设置分机上/下棚
    case shed                                       = 0x7
    /// 命令码=0x08(RW),读写分机烤次及日期时间
    case time                                       = 0x8
    /// 命令码=0x09(R),读取分机记录数据
    case record                                     = 0x9
    /// 命令码=0x0A(W)，远程绑定与解绑命令
    case bind                                       = 0xA
    
    /// 命令码=0x10(R),读取分机生物质燃烧机状态
    case burner_status                              = 0x10
    /// 命令码=0x12(W),生物质燃烧机点火
    case burner_fire                                = 0x11
    /// 命令码=0x13(W),生物质燃烧机跳过点火
    case burner_pass_fire                           = 0x12
    /// 命令码=0x14(W),生物质燃烧机关机命令
    case burner_off                                 = 0x13
    /// 心跳
    case bindDevice                                 = 0xF7
    /// 编辑设备
    case editDevice                                 = 0xF8
    /// 设备列表
    case devices                                    = 0xF9
    /// 删除设备
    case deleteDevice                               = 0xFA
    /// 添加设备
    case addDevice                                  = 0xFB
    /// 用户信息
    case userInfo                                   = 0xFC
    /// 修改密码
    case password                                   = 0xFD
    /// 登录
    case login                                      = 0xFE
    /// 注册命令
    case register                                   = 0xFF
}

extension SubOrder: Comparable {
    static func < (lhs: SubOrder, rhs: SubOrder) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }
}

enum RW: UInt8 {
    case read = 0x0
    case write = 0x40
}
