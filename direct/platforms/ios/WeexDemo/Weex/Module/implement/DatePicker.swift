//
//  DatePicker.swift
//  WeexDemo
//
//  Created by zzzl on 2018/11/22.
//  Copyright © 2018 zzzl. All rights reserved.
//

import Foundation
import SwiftyJSON

extension DatePicker {
    private struct AssociatedKeys {
        static var yearKey: [Int]?
        static var monthKey: [Int]?
        static var dayKey: [Int]?
        static var hourKey: [Int]?
        static var minuteKey: [Int]?
    }
    
    fileprivate var yearArr: [Int]? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.yearKey) as? [Int]
        }
        set {
            if let newValue = newValue {
                objc_setAssociatedObject(self, &AssociatedKeys.yearKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }
    
    fileprivate var monthArr: [Int]? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.monthKey) as? [Int]
        }
        set {
            if let newValue = newValue {
                objc_setAssociatedObject(self, &AssociatedKeys.monthKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }
    
    fileprivate var dayArr: [Int]? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.dayKey) as? [Int]
        }
        set {
            if let newValue = newValue {
                objc_setAssociatedObject(self, &AssociatedKeys.dayKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }
    
    fileprivate var hourArr: [Int]? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.hourKey) as? [Int]
        }
        set {
            if let newValue = newValue {
                objc_setAssociatedObject(self, &AssociatedKeys.hourKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }
    
    fileprivate var minuteArr: [Int]? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.minuteKey) as? [Int]
        }
        set {
            if let newValue = newValue {
                objc_setAssociatedObject(self, &AssociatedKeys.minuteKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }
    
    @objc func create(_ option: [String: AnyHashable], _ callback: @escaping WXModuleKeepAliveCallback) -> Void {
        self.callback = callback
        calendar = Calendar(identifier: .gregorian)
        
        let op = JSON(option)
        
        if let min = op["min"].string {
            minDate = Date.create(string: min)
        } else {
            minDate = Date.create(string: "1970-01-01 00:00")
        }
        
        if let max = op["max"].string {
            maxDate = Date.create(string: max)
        } else {
            maxDate = Date.create(string: "2099-12-12 23:59")
        }
        let selectDate = Date.create(string: op["selectDate"].string)
        let selectCp = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: selectDate)
        yearArr = yearRange()
        yearRow = NSNumber(value: yearArr?.firstIndex(of: selectCp.year ?? 0) ?? 0)
        
        monthArr = monthRange(yearRow.intValue)
        monthRow = NSNumber(value: monthArr?.firstIndex(of: selectCp.month ?? 0) ?? 0)
        
        dayArr = dayRange(yearRow.intValue, monthRow.intValue)
        dayRow = NSNumber(value: dayArr?.firstIndex(of: selectCp.day ?? 0) ?? 0)
        
        hourArr = hourRange(yearRow.intValue, monthRow.intValue, dayRow.intValue)
        hourRow = NSNumber(value: hourArr?.firstIndex(of: selectCp.hour ?? 0) ?? 0)
        
        minuteArr = minuteRange(yearRow.intValue, monthRow.intValue, dayRow.intValue, hourRow.intValue)
        minuteRow = NSNumber(value: minuteArr?.firstIndex(of: selectCp.minute ?? 0) ?? 0)
        
        let bvc = weexInstance.viewController as! BaseViewController
        let frame = bvc.weexView?.frame ?? .zero
        
        picker = UIPickerView(frame: CGRect.zero)
        picker.frame = CGRect(x: 0, y: frame.maxY - picker.frame.height, width: frame.width, height: picker.frame.height)
        picker.delegate = self
        picker.dataSource = self
        picker.backgroundColor = .white
        picker.selectRow(yearRow.intValue, inComponent: 0, animated: false)
        picker.selectRow(monthRow.intValue, inComponent: 1, animated: false)
        picker.selectRow(dayRow.intValue, inComponent: 2, animated: false)
        picker.selectRow(hourRow.intValue, inComponent: 3, animated: false)
        picker.selectRow(minuteRow.intValue, inComponent: 4, animated: false)
        
        bgView = UIView(frame: UIScreen.main.bounds)
        bgView.backgroundColor = UIColor(white: 0, alpha: 0.6)
        weexInstance.viewController.view.addSubview(bgView)
        bgView.addSubview(picker)
        let tap = UITapGestureRecognizer(target: self, action: #selector(hide(_:)))
        bgView.addGestureRecognizer(tap)
        
        isAnimate = false
        show()
    }
    
    @objc func show() {
        guard !isAnimate else {
            return
        }
        var frame = picker.frame
        let bvc = weexInstance.viewController as! BaseViewController
        let weexframe = bvc.weexView?.frame ?? .zero
        frame.origin.y = weexframe.maxY
        picker.frame = frame
        isAnimate = true
        
        UIView.animate(withDuration: 0.3, animations: {
            frame.origin.y = weexframe.maxY - frame.height
            self.picker.frame = frame
        }) { (finish) in
            if finish {
                self.isAnimate = false
            }
        }
    }
    
    @objc func hide(_ tap: UITapGestureRecognizer) -> Void {
        guard !isAnimate else {
            return
        }
        var frame = picker.frame
        let bvc = weexInstance.viewController as! BaseViewController
        let weexframe = bvc.weexView?.frame ?? .zero
        frame.origin.y = weexframe.maxY
        picker.frame = frame
        isAnimate = true
        
        UIView.animate(withDuration: 1, animations: {
            frame.origin.y = weexframe.maxY
            self.picker.frame = frame
        }) { (finish) in
            if finish {
                self.isAnimate = false
                self.bgView.removeFromSuperview()
            }
        }
    }
}

extension DatePicker: UIPickerViewDelegate, UIPickerViewDataSource {
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 5
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var row = 0
        
        switch component {
        case 0:
            row = yearRange().count
        case 1:
            let row0 = pickerView.selectedRow(inComponent: 0)
            row = monthRange(row0).count
        case 2:
            let row0 = pickerView.selectedRow(inComponent: 0)
            let row1 = pickerView.selectedRow(inComponent: 1)
            row = dayRange(row0, row1).count
        case 3:
            let row0 = pickerView.selectedRow(inComponent: 0)
            let row1 = pickerView.selectedRow(inComponent: 1)
            let row2 = pickerView.selectedRow(inComponent: 2)
            row = hourRange(row0, row1, row2).count
        case 4:
            let row0 = pickerView.selectedRow(inComponent: 0)
            let row1 = pickerView.selectedRow(inComponent: 1)
            let row2 = pickerView.selectedRow(inComponent: 2)
            let row3 = pickerView.selectedRow(inComponent: 3)
            row = minuteRange(row0, row1, row2, row3).count
        default:
            break
        }
        return row
    }
    
    public func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        let width = UIScreen.main.bounds.width / 5.0
        
        switch component {
        case 0:
            return width + 16
        default:
            return width - 5
        }
    }
    
    public func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 30
    }
    
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        var title = ""
        let formatter = NumberFormatter()
        
        switch component {
        case 0:
            formatter.minimumIntegerDigits = 4
            title = formatter.string(from: NSNumber(value: yearRange()[row])) ?? ""
            title += "年"
        case 1:
            formatter.minimumIntegerDigits = 2
            let row0 = pickerView.selectedRow(inComponent: 0)
            title = formatter.string(from: NSNumber(value: monthRange(row0)[row])) ?? ""
            title += "月"
        case 2:
            formatter.minimumIntegerDigits = 2
            let row0 = pickerView.selectedRow(inComponent: 0)
            let row1 = pickerView.selectedRow(inComponent: 1)
            title = formatter.string(from: NSNumber(value: dayRange(row0, row1)[row])) ?? ""
            title += "日"
        case 3:
            formatter.minimumIntegerDigits = 2
            let row0 = pickerView.selectedRow(inComponent: 0)
            let row1 = pickerView.selectedRow(inComponent: 1)
            let row2 = pickerView.selectedRow(inComponent: 2)
            title = formatter.string(from: NSNumber(value: hourRange(row0, row1, row2)[row])) ?? ""
            title += "时"
        case 4:
            formatter.minimumIntegerDigits = 2
            let row0 = pickerView.selectedRow(inComponent: 0)
            let row1 = pickerView.selectedRow(inComponent: 1)
            let row2 = pickerView.selectedRow(inComponent: 2)
            let row3 = pickerView.selectedRow(inComponent: 3)
            title = formatter.string(from: NSNumber(value: minuteRange(row0, row1, row2, row3)[row])) ?? ""
            title += "分"
        default:
            break
        }
        return title
    }
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        switch component {
        case 0:
            yearRow = NSNumber(value: row)
        case 1:
            monthRow = NSNumber(value: row)
        case 2:
            dayRow = NSNumber(value: row)
        case 3:
            hourRow = NSNumber(value: row)
        case 4:
            minuteRow = NSNumber(value: row)
        default:
            break
        }
        pickerView.reloadAllComponents()
        let year = yearRange()[yearRow.intValue]
        let month = monthRange(yearRow.intValue)[monthRow.intValue]
        let day = dayRange(yearRow.intValue, monthRow.intValue)[dayRow.intValue]
        let hour = hourRange(yearRow.intValue, monthRow.intValue, dayRow.intValue)[hourRow.intValue]
        let minute = minuteRange(yearRow.intValue, monthRow.intValue, dayRow.intValue, hourRow.intValue)[minuteRow.intValue]
        callback(["year": year, "month": month, "day": day, "hour": hour, "minute": minute], true)
    }
}

extension DatePicker {
    func yearRange() -> [Int] {
        let max         = calendar.component(.year, from: maxDate)
        let min         = calendar.component(.year, from: minDate)
        return (min..<max).map({$0})
    }
    
    func monthRange(_ yearRow: Int) -> [Int] {
        let yearR = yearRange()
        let max         = calendar.component(.month, from: maxDate)
        let min         = calendar.component(.month, from: minDate)
        let minR        = calendar.range(of: .month, in: .year, for: minDate)
        
        var monthR: Range<Int>
        
        if yearRow == 0 {
            monthR = min..<(minR?.upperBound ?? 0)
        } else if yearRow == yearR.count - 1 {
            monthR = 0..<max
        } else {
            var dateC = DateComponents()
            dateC.year = yearR[yearRow]
            monthR = calendar.range(of: .month, in: .year, for: dateC.date ?? Date()) ?? 0..<0
        }
        return monthR.map({$0})
    }
    
    func dayRange(_ yearRow: Int, _ monthRow: Int) -> [Int] {
        let yearR = yearRange()
        let monthR = monthRange(yearRow)
        
        let max         = calendar.component(.day, from: maxDate)
        let min         = calendar.component(.day, from: minDate)
        let minR        = calendar.range(of: .day, in: .month, for: minDate)
        
        var dayR: Range<Int>
        
        if yearRow == 0 && monthRow == 0 {
            dayR = min..<(minR?.upperBound ?? 0)
        } else if yearRow == yearR.count - 1
            && monthRow == monthR.count - 1 {
            dayR = 0..<max
        } else {
            var dateC = DateComponents()
            dateC.year = yearR[yearRow]
            dateC.month = monthR[monthRow]
            dayR = calendar.range(of: .day, in: .month, for: dateC.date ?? Date()) ?? 0..<0
        }
        return dayR.map({$0})
    }
    
    func hourRange(_ yearRow: Int, _ monthRow: Int, _ dayRow: Int) -> [Int] {
        let yearR = yearRange()
        let monthR = monthRange(yearRow)
        let dayR = dayRange(yearRow, monthRow)
        
        let max         = calendar.component(.hour, from: maxDate)
        let min         = calendar.component(.hour, from: minDate)
        let minR        = calendar.range(of: .hour, in: .day, for: minDate)
        
        var hourR: Range<Int>
        
        if yearRow == 0 && monthRow == 0 && dayRow == 0 {
            hourR = min..<(minR?.upperBound ?? 0)
        } else if yearRow == yearR.count - 1
            && monthRow == monthR.count - 1
            && dayRow == dayR.count - 1 {
            hourR = 0..<max
        } else {
            var dateC = DateComponents()
            dateC.year = yearR[yearRow]
            dateC.month = monthR[monthRow]
            dateC.day = dayR[dayRow]
            hourR = calendar.range(of: .hour, in: .day, for: dateC.date ?? Date()) ?? 0..<0
        }
        return hourR.map({$0})
    }
    
    func minuteRange(_ yearRow: Int, _ monthRow: Int, _ dayRow: Int, _ hourRow: Int) -> [Int] {
        let yearR = yearRange()
        let monthR = monthRange(yearRow)
        let dayR = dayRange(yearRow, monthRow)
        let hourR = hourRange(yearRow, monthRow, dayRow)
        
        let max         = calendar.component(.minute, from: maxDate)
        let min         = calendar.component(.minute, from: minDate)
        let minR        = calendar.range(of: .minute, in: .hour, for: minDate)
        
        var minuteR: Range<Int>
        
        if yearRow == 0 && monthRow == 0 && dayRow == 0 && hourRow == 0 {
            minuteR = min..<(minR?.upperBound ?? 0)
        } else if yearRow == yearR.count - 1
            && monthRow == monthR.count - 1
            && dayRow == dayR.count - 1
            && hourRow == hourR.count - 1 {
            minuteR = 0..<max
        } else {
            var dateC = DateComponents()
            dateC.year = yearR[yearRow]
            dateC.month = monthR[monthRow]
            dateC.day = dayR[dayRow]
            dateC.hour = hourR[hourRow]
            minuteR = calendar.range(of: .minute, in: .hour, for: dateC.date ?? Date()) ?? 0..<0
        }
        return minuteR.map({$0})
    }
}
