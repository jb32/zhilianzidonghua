//
//  StringExd.swift
//  WeexDemo
//
//  Created by zzzl on 2019/2/14.
//  Copyright © 2019 zzzl. All rights reserved.
//

import Foundation

extension String {
    var psdBytes: [UInt8]? {
        guard let int = UInt32(self) else { return nil }
        let hight = UInt8((int & 0xFF0000) >> 16)
        let middle = UInt8((int & 0xFF00) >> 8)
        let low = UInt8(int & 0xFF)
        
        return [low, middle, hight]
    }
}

extension String {
    /// 罗马数字转化Int类型
    var roman: Int {
        var res = 0
        let map: [Character: Int] = ["I": 1, "V": 5, "X": 10, "L": 50, "C": 100, "D": 500, "M": 1000]
        
        for (i, value) in enumerated() {
            guard let current = map[value] else { continue }
            
            if i == count - 1 {
                res += current
            } else {
                let nextStr = self[index(after: index(startIndex, offsetBy: i))]
                guard let next = map[nextStr] else { continue }
                
                if next <= current {
                    res += current
                } else {
                    res -= current
                }
            }
        }
        return res
    }
}
