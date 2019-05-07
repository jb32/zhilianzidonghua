//
//  AlarmStatus.swift
//  WeexDemo
//
//  Created by zzzl on 2019/1/7.
//  Copyright © 2019 zzzl. All rights reserved.
//

import Foundation

struct AlarmStatus: OptionSet {
    var rawValue: UInt8
    
    /// Bit7     温度传感器故障
    static let dry = AlarmStatus(rawValue: 0x80)
    /// Bit6     湿度传感器故障
    static let wet = AlarmStatus(rawValue: 0x40)
    /// Bit5     循环风机缺相
    static let phase = AlarmStatus(rawValue: 0x20)
    /// Bit4     循环风机过载
    static let fanOver = AlarmStatus(rawValue: 0x10)
    /// Bit3     电压超高限
    static let voltageHigh = AlarmStatus(rawValue: 0x08)
    /// Bit2     电压超低限
    static let voltageLow = AlarmStatus(rawValue: 0x04)
    /// Bit1     温度偏温
    static let dryHigh = AlarmStatus(rawValue: 0x02)
    /// Bit0     湿度偏温
    static let wetHigh = AlarmStatus(rawValue: 0x01)
}

extension AlarmStatus {
    init(_ value: UInt8) {
        self.rawValue = value
    }
}

extension AlarmStatus {
    func des() -> [String] {
        var d = [String]()
        if contains(.dry) {
            d.append("温度传感器故障")
        }
        if contains(.wet) {
            d.append("湿度传感器故障")
        }
        if contains(.phase) {
            d.append("循环风机缺相")
        }
        if contains(.fanOver) {
            d.append("循环风机过载")
        }
        if contains(.voltageHigh) {
            d.append("电压超高限")
        }
        if contains(.voltageLow) {
            d.append("电压超低限")
        }
        if contains(.dryHigh) {
            d.append("温度偏温")
        }
        if contains(.wetHigh) {
            d.append("湿度偏温")
        }
        return d
    }
}

