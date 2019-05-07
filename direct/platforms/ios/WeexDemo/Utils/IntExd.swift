//
//  IntExd.swift
//  WeexDemo
//
//  Created by zzzl on 2019/2/14.
//  Copyright © 2019 zzzl. All rights reserved.
//

import Foundation

extension Int {
    func bytes(limit: Int? = nil) -> [UInt8] {
        var lengths = [UInt8]()
        
        if let limit = limit {
            for i in 0..<limit {
                let l = UInt8((self >> (i * 8)) & 0xFF)
                lengths.append(l)
            }
        } else {
            var i = 0
            while UInt8((self >> (i * 8)) & 0xFF) != 0 {
                let l = UInt8((self >> (i * 8)) & 0xFF)
                lengths.append(l)
                i += 1
            }
        }
        return lengths
    }
}


