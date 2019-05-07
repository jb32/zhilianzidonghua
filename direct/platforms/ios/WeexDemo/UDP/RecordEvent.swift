//
//  RecordEvent.swift
//  WeexDemo
//
//  Created by zzzl on 2019/1/25.
//  Copyright © 2019 zzzl. All rights reserved.
//

import Foundation

struct RecordEvent: OptionSet {
    var rawValue: UInt8
    
    static let sensor = RecordEvent(rawValue: 0x1 << 6)
    static let phase = RecordEvent(rawValue: 0x1 << 5)
    static let over = RecordEvent(rawValue: 0x1 << 4)
    static let powerOutage = RecordEvent(rawValue: 0x1 << 3)
    static let dryOver = RecordEvent(rawValue: 0x1 << 2)
    static let wetOver = RecordEvent(rawValue: 0x1 << 1)
}

extension RecordEvent {
    func des() -> [String] {
        var arr = [String]()
        
        if contains(.sensor) {
            arr.append("传感器故障")
        }
        
        if contains(.phase) {
            arr.append("缺相")
        }
        if contains(.over) {
            arr.append("过载")
        }
        if contains(.powerOutage) {
            arr.append("停电")
        }
        if contains(.dryOver) {
            arr.append("温度超限")
        }
        if contains(.wetOver) {
            arr.append("湿度超限")
        }
        return arr
    }
}
