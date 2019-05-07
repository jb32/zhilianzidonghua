//
//  UInt8Exd.swift
//  WeexDemo
//
//  Created by zzzl on 2019/2/14.
//  Copyright © 2019 zzzl. All rights reserved.
//

import Foundation

extension UInt8 {
    /// 罗马数字
    var roman: String {
        var res = ""
        var temp = self
        
//        while temp >= 1000 {
//            res += "M"
//            temp -= 100
//        }
//
//        while temp >= 900 {
//            res += "CM"
//            temp -= 900
//        }
//
//        while temp >= 500 {
//            res += "D"
//            temp -= 500
//        }
//
//        while temp >= 400 {
//            res += "CD"
//            temp -= 400
//        }
//        由于UInt8的取值范围是0-255，去掉不可能的判断
        while temp >= 100 {
            res += "C"
            temp -= 100
        }
        while temp >= 90 {
            res += "XC"
            temp -= 90
        }
        while temp >= 50 {
            res += "L"
            temp -= 50
        }
        while temp >= 40 {
            res += "XL"
            temp -= 40
        }
        while temp >= 10 {
            res += "X"
            temp -= 10
        }
        while temp >= 9 {
            res += "IX"
            temp -= 9
        }
        while temp >= 5 {
            res += "V"
            temp -= 5
        }
        while temp >= 4 {
            res += "IV"
            temp -= 4
        }
        while temp >= 1 {
            res += "I"
            temp -= 1
        }
        
        return res
    }
}

extension UInt8 {
    /// 1 => A; 2 => B, 依次类推 4 => D
    var xvHao: String {
        let num = self + 64
        let unincode = UnicodeScalar(num)
        let char = Character(unincode)
        return String(char)
    }
}
