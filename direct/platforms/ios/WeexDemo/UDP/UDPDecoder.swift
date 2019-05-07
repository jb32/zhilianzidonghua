//
//  UDPDecode.swift
//  WeexDemo
//
//  Created by zzzl on 2018/12/30.
//  Copyright © 2018 zzzl. All rights reserved.
//

import Foundation

struct UDPDecoder {
    private var data: [UInt8]
    private var index = 0
    
    init(data: [UInt8]) {
        self.data = data
    }
    
    mutating func iterator<T: BinaryInteger>(_ offset: Int, isLimited: Bool = true) -> T {
        var sub: ArraySlice<UInt8>
        
        if isLimited, let endIndex = data.index(index, offsetBy: offset, limitedBy: data.endIndex) {
            let end = endIndex
            sub = data[index..<end]
        } else {
            let arr = Array(repeating: UInt8(0), count: index + offset)
            sub = arr[index..<arr.endIndex]
        }
        index = index + offset
        
        return UDPDecoder.parse(sub)
    }
    
    static func parse<T: BinaryInteger>(_ data: ArraySlice<UInt8>) -> T {
        let offset = data.count
        let datas = Array(data)
        
        if offset == 2 {
            var result: UInt16 = 0
            
            for i in 0..<offset {
                result |= (UInt16(datas[i]) << (i * 8))
            }
            return T(truncatingIfNeeded: result)
        } else if offset == 3 || offset == 4 {
            var result: UInt32 = 0
            
            for i in 0..<offset {
                result |= (UInt32(datas[i]) << (i * 8))
            }
            return T(truncatingIfNeeded: result)
        }
        if datas.count == 0 {
            return T(truncatingIfNeeded: 0)
        }
        return T(truncatingIfNeeded: datas[0])
    }
}
