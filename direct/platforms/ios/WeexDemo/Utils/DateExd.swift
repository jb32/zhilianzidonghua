//
//  DateExtend.swift
//  WeexDemo
//
//  Created by zzzl on 2018/11/22.
//  Copyright © 2018 zzzl. All rights reserved.
//

import Foundation

extension Date {
    static func create(string: String?) -> Date {
        guard let string = string else { return Date() }
        
        let times = string.components(separatedBy: ["-", " ", ":"])
        
        var formatStr = ""
        
        let years = Array(repeating: "y", count: 4)
        formatStr += years.joined(separator: "")
        let months = Array(repeating: "M", count: times[1].count)
        formatStr += "-" + months.joined(separator: "")
        let days = Array(repeating: "d", count: times[2].count)
        formatStr += "-" + days.joined(separator: "")
        
        if times.count >= 4 {
            let hours = Array(repeating: "H", count: times[3].count)
            formatStr += " " + hours.joined(separator: "")
        }
        
        if times.count >= 5 {
            let minutes = Array(repeating: "m", count: times[4].count)
            formatStr += ":" + minutes.joined(separator: "")
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = formatStr
        formatter.locale = Locale(identifier: "zh_CN")
        
        if let date = formatter.date(from: string) {
            return date
        }
        return Date()
    }
}
