//
//  BurnerAlarm.swift
//  WeexDemo
//
//  Created by zzzl on 2019/2/13.
//  Copyright © 2019 zzzl. All rights reserved.
//

import Foundation

struct BurnerAlarm: OptionSet {
    var rawValue: UInt8
    /// Bit2     热电偶故障
    static let thermocouple = BurnerAlarm(rawValue: 0x04)
    /// Bit1     旋转电机故障
    static let rotateFan = BurnerAlarm(rawValue: 0x02)
    /// Bit0     进料电机故障
    static let feedFan = BurnerAlarm(rawValue: 0x01)
}

extension BurnerAlarm {
    func des() -> [String] {
        var d = [String]()
        
        if contains(.thermocouple) {
            d.append("热电偶故障")
        }
        if contains(.rotateFan) {
            d.append("旋转电机故障")
        }
        if contains(.feedFan) {
            d.append("进料电机故障")
        }
        return d
    }
}
