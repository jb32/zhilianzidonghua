//
//  ArrayExd.swift
//  WeexDemo
//
//  Created by zzzl on 2019/2/14.
//  Copyright © 2019 zzzl. All rights reserved.
//

import Foundation

extension Array where Element: Equatable {
    func filter(duplicates option: (_ old: Element, _ new: Element) -> Element) -> [Element] {
        var result = [Element]()
        for value in self {
            if let i = result.firstIndex(of: value) {
                result[i] = option(result[i], value)
            } else {
                result.append(value)
            }
        }
        return result
    }
}

extension Array where Element == UInt8 {
    var int: Int {
        var result = 0
        
        for (i, item) in enumerated() {
            result |= Int(item) << (i * 8)
        }
        return result
    }
    
    var uint16: UInt16 {
        var result: UInt16 = 0
        
        for i in 0..<2 {
            result |= UInt16(self[i]) << (i * 8)
        }
        return result
    }
    
    var uint32: UInt32 {
        var result: UInt32 = 0
        let len = count < 4 ? count : 4
        
        for i in 0..<len {
            result |= UInt32(self[i]) << (i * 8)
        }
        return result
    }
    
    var str: String? {
        return String(bytes: self, encoding: .utf8)
    }
}



