//
//  DeviceState.swift
//  WeexDemo
//
//  Created by zzzl on 2018/12/25.
//  Copyright © 2018 zzzl. All rights reserved.
//

import Foundation
import SwiftyJSON

struct PerformStatus: OptionSet {
    var rawValue: UInt8
    
    /// Bit7     1表示允许报警
    static let alarm            = PerformStatus(rawValue: 0b10000000)
    /// Bit6     1表示电压超限保护
    static let voltageProtect   = PerformStatus(rawValue: 0b01000000)
    /// Bit5     1表示电压闪烁
    static let voltageWobble    = PerformStatus(rawValue: 0b00100000)
    /// Bit4     1表示循环风机开启
    static let fanOn            = PerformStatus(rawValue: 0b00010000)
    /// Bit3     1表示循环风机高速
    static let fanHight         = PerformStatus(rawValue: 0b00001000)
    /// Bit2     1表示循环风机低速
    static let fanLow           = PerformStatus(rawValue: 0b00000100)
    /// Bit1     1表示加热开启
    static let warm             = PerformStatus(rawValue: 0b00000010)
    /// Bit0     1表示进风门开启
    static let intakeOn         = PerformStatus(rawValue: 0b00000001)
}

extension PerformStatus {
    init(_ value: UInt8) {
        self.rawValue = value
    }
}
