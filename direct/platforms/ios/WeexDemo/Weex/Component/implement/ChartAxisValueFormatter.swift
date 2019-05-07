//
//  ChartAxisValueFormatter.swift
//  WeexDemo
//
//  Created by zzzl on 2018/11/2.
//  Copyright © 2018 zzzl. All rights reserved.
//

import UIKit
import Charts

class ChartAxisValueFormatter: NSObject {
    var values: [Any]?
    
    override init() {
        super.init()
    }
    
    init(_ values: [Any]) {
        self.values = values
        
        super.init()
    }
}


extension ChartAxisValueFormatter: IAxisValueFormatter {
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        if values == nil {
            return "\(value)"
        }
        
        if values is [[Double]] {
            return String(format: "%.1f%℃", value)
        } else if let num = values![Int(value)] as? Double {
            let str = "\(num)".components(separatedBy: ".").first ?? "0"
            
//            if strs.count == 2 && Int(strs[1]) ?? 0 > 0 {
//                return str
//            } else {
//                return strs[0]
//            }
            return str
        }
        return "0"
    }
}

extension ChartAxisValueFormatter: IValueFormatter {
    func stringForValue(_ value: Double, entry: ChartDataEntry, dataSetIndex: Int, viewPortHandler: ViewPortHandler?) -> String {
        return String(format: "%.1f%%", value)
    }
}
