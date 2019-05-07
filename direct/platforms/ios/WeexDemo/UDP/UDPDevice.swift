//
//  UDPDevice.swift
//  WeexDemo
//
//  Created by zzzl on 2019/1/30.
//  Copyright © 2019 zzzl. All rights reserved.
//

import Foundation
import SwiftyJSON

class UDPDevice {
    var order: Order
    var data: JSON!
    var rspCode: UInt8?
    var isAlarm = false
    var alarmDes = ""
    
    init?(_ byteArr: [UInt8]) {
        var bytes = byteArr
        let checks = bytes[0..<bytes.index(before: bytes.endIndex)]
        var sum = 0
        
        for byte in checks {
            sum += Int(byte)
        }
        
        let orderValue = bytes.removeFirst()/// 命令码
        rspCode = bytes.removeFirst()/// 应答码
        
        guard let order = Order(rawValue: orderValue), !order.isService() else {
            return nil
        }
        self.order = order
        /// 校验码
        var check: Int
        
        if rspCode! & 0x80 == 0x80 {
            let length = UDPDecoder.parse(bytes[0..<4]) as Int /// 应答数据长度
            check = UDPDecoder.parse(bytes.suffix(4)) as Int /// 校验码
            guard bytes.count > 8 else { return nil }
            bytes.removeFirst(4)
            bytes.removeLast(4)
            /// 长度校验
            if bytes.count != length {
                return nil
            }
        } else {
            guard bytes.count > 1 else { return nil }
            let length = Int(truncatingIfNeeded: bytes.removeFirst())/// 应答数据长度
            guard bytes.count > 1 else { return nil }
            check = Int(truncatingIfNeeded: bytes.removeLast())/// 校验码
            /// 长度校验
            if bytes.count != length {
                return nil
            }
        }
        sum += check
        
        if UInt8(truncatingIfNeeded: sum) != 0 {
            return nil
        }
        var data = decode(bytes)
        data["rspCode"] = JSON(rspCode!)
        self.data = JSON(["data": data, "msg": ""])
    }
    init(order: Order, data: JSON) {
        self.order = order
        self.data = data
    }
}

extension UDPDevice {
    /// 解码
    func decode(_ bytes: [UInt8]) -> JSON {
        var json: JSON
        
        switch order.sub {
        case .status:
            json = decode(status: bytes)
        case .realTime:
            json = decode(realTime: bytes)
        case .curves:
            json = decode(curves: bytes)
        case .curve:
            json = decode(curve: bytes)
        case .run:
            json = decode(run: bytes)
        case .curveCoding:
            json = decode(curveCoding: bytes)
        case .curveNum:
            json = decode(curveNum: bytes)
        case .shed:
            json = decode(shed: bytes)
        case .time:
            json = decode(time: bytes)
        case .record:
            json = decode(record: bytes)
        case .bind:
            json = decode(bind: bytes)
        case .burner_status:
            json = decode(burner_status: bytes)
        case .burner_fire:
            json = decode(burner_fire: bytes)
        case .burner_pass_fire:
            json = decode(burner_pass_fire: bytes)
        case .burner_off:
            json = decode(burner_off: bytes)
        default:
            json = JSON()
        }
        return json
    }
    
    /// 命令码=0x00(R),读取分机设备类型、协议版本、软件版本
    func decode(status bytes: [UInt8]) -> JSON {
        var json = JSON()
        var decoder = UDPDecoder(data: bytes)
        
        let deviceType = DeviceType(rawValue: decoder.iterator(4))
        json["type"] = JSON(deviceType.arr)
        let treaty0 = decoder.iterator(1) as UInt8
        let treaty1 = decoder.iterator(1) as UInt8
        
        let treaty = "V" + String(treaty0, radix: 16, uppercase: true) + "." + String(treaty1, radix: 16, uppercase: true)
        json["treatyVersions"] = JSON(treaty)
        let version0 = decoder.iterator(1) as UInt8
        let version1 = decoder.iterator(1) as UInt8
        
        let versions = "V" + String(version0, radix: 16, uppercase: true) + "." + String(version1, radix: 16, uppercase: true)
        json["versions"] = JSON(versions)
        
        return json
    }
    /// 命令码=0x01(R),读取分机实时数据
    func decode(realTime bytes: [UInt8]) -> JSON {
        var json = JSON()
        var decoder = UDPDecoder(data: bytes)
        
        let status0 = decoder.iterator(1) as UInt8
        json["isbind"] = JSON((status0 & 0x20) >> 5 == 1)
        json["curveNum"] = JSON(status0 & 0x1F)
        
        let status1 = decoder.iterator(1) as UInt8
        
        json["coding"] = JSON(status1 & 0x0F)
        json["run"] = JSON((status1 & 0x10) >> 4)
        json["shed"] = JSON((status1 & 0x20) >> 5)
        json["subAlarm"] = JSON((status1 & 0x40) >> 6)
        
        json["dryT"] = JSON(Float(decoder.iterator(2) as UInt16) / 100)
        json["wetT"] = JSON(Float(decoder.iterator(2) as UInt16) / 100)
        
        let hour = decoder.iterator(1) as UInt8
        let miunte = decoder.iterator(1) as UInt8
        json["time"] = JSON("\(hour) h \(miunte) m")
        
        let hourT = decoder.iterator(1) as UInt8
        let miunteT = decoder.iterator(1) as UInt8
        json["timeTotal"] = JSON("\(hourT) h \(miunteT) m")
        
        json["dryAim"] = JSON(Float(decoder.iterator(2) as UInt16) / 100)
        json["wetAim"] = JSON(Float(decoder.iterator(2) as UInt16) / 100)
        json["voltage"] = JSON(decoder.iterator(2) as UInt16)
        
        let performStatus = PerformStatus(decoder.iterator(1) as UInt8)
        json["isAlarm"] = JSON(performStatus.contains(.alarm))
        
        var voltageStatus = [String]()
        if performStatus.contains(.voltageProtect) {
            voltageStatus.append("电压超限保护")
        }
        if performStatus.contains(.voltageWobble) {
            voltageStatus.append("电压闪烁")
        }
        json["voltageStatus"] = JSON(voltageStatus)
        
        json["isFanOn"] = JSON(performStatus.contains(.fanOn))
        json["fan"] = JSON(performStatus.contains(.fanHight) ? "高" : (performStatus.contains(.fanLow) ? "低" : ""))
        json["warm"] = JSON(performStatus.contains(.warm))
        json["intakeOn"] = JSON(performStatus.contains(.intakeOn))
        
        let alarmStatus = AlarmStatus(decoder.iterator(1))
        let status = alarmStatus.des()
        json["alarmStatus"] = JSON(status)
        isAlarm = status.count > 0 ? true : false
        alarmDes = status.joined(separator: ",")
        
        json["dryTHelp"] = JSON(Float(decoder.iterator(2) as UInt16) / 100)
        json["wetTHelp"] = JSON(Float(decoder.iterator(2) as UInt16) / 100)
        
        var curve = JSON()
        curve["dry"] = JSON(decoder.iterator(1) as UInt8)
        
        let wet = decoder.iterator(1) as UInt8
        let wetd = ((wet >> 7) & 0x1) == 0 ? 0 : Float(0.5)
        let wetF = Float(wet & 0x7F) + wetd
        curve["wet"] = JSON(wetF)
        
        curve["up"] = JSON(decoder.iterator(1) as UInt8)
        curve["steady"] = JSON(decoder.iterator(1) as UInt8)
        
        json["currentCurve"] = curve
        
        return json
    }
    /// 命令码=0x02(RW)，读写分机整条曲线数据
    func decode(curves bytes: [UInt8]) -> JSON {
        var json = JSON()
        var decoder = UDPDecoder(data: bytes)
        let curve = decoder.iterator(1) as UInt8
        json["coding"] = JSON(curve & 0x0F)
        
        var curves = [[String: Float]]()
        
        for _ in 0..<10 {
            var _curve = [String: Float]()
            _curve["dry"] = Float(decoder.iterator(1) as UInt8)
            let wet = decoder.iterator(1) as UInt8
            _curve["wet"] = Float(wet & 0x7F) + ((wet & 0x80) == 0x80 ? 0.5 : 0.0)
            _curve["up"] = Float(decoder.iterator(1) as UInt8)
            _curve["steady"] = Float(decoder.iterator(1) as UInt8)
            _ = decoder.iterator(2) as UInt16
            curves.append(_curve)
        }
        json["curves"] = JSON(curves)
        
        return json
    }
    /// 命令码=0x03(RW)，读写分机曲线段数据
    func decode(curve bytes: [UInt8]) -> JSON {
        var json = JSON()
        var decoder = UDPDecoder(data: bytes)
        let curve = decoder.iterator(1) as UInt8
        json["coding"] = JSON(curve & 0x0F)
        json["curveNum"] = JSON(decoder.iterator(1) as UInt8)
        
        var _curve = [String: Float]()
        _curve["dry"] = Float(decoder.iterator(1) as UInt8)
        let wet = decoder.iterator(1) as UInt8
        _curve["wet"] = Float(wet & 0x7F) + ((wet & 0x80) == 0x80 ? 0.5 : 0.0)
        _curve["up"] = Float(decoder.iterator(1) as UInt8)
        _curve["steady"] = Float(decoder.iterator(1) as UInt8)
        
        json["curve"] = JSON(_curve)
        
        return json
    }
    /// 命令码=0x04(W)，分机运行/停止控制
    func decode(run bytes: [UInt8]) -> JSON {
        var json = JSON()
        var decoder = UDPDecoder(data: bytes)
        let run = decoder.iterator(1) as UInt8
        json["isRun"] = JSON(run == 1)
        return json
    }
    /// 命令码=0x05(W)，选择分机烘烤曲线
    func decode(curveCoding bytes: [UInt8]) -> JSON {
        var json = JSON()
        var decoder = UDPDecoder(data: bytes)
        let run = decoder.iterator(1) as UInt8
        json["coding"] = JSON(run)
        return json
    }
    /// 命令码=0x06(W)，设置分机运行段
    func decode(curveNum bytes: [UInt8]) -> JSON {
        var json = JSON()
        var decoder = UDPDecoder(data: bytes)
        let num = decoder.iterator(1) as UInt8
        json["curveNum"] = JSON(num)
        return json
    }
    /// 命令码=0x07(W)，设置分机上/下棚
    func decode(shed bytes: [UInt8]) -> JSON {
        var json = JSON()
        var decoder = UDPDecoder(data: bytes)
        let shed = decoder.iterator(1) as UInt8
        json["shed"] = JSON(shed)
        return json
    }
    /// 命令码=0x08(RW)，读写分机烤次及日期时间
    func decode(time bytes: [UInt8]) -> JSON {
        var json = JSON()
        var decoder = UDPDecoder(data: bytes)
        let num = decoder.iterator(1) as UInt8
        json["bakeTimes"] = JSON(num & 0x0F)
        json["year"] = JSON(decoder.iterator(1) as UInt8)
        json["month"] = JSON(decoder.iterator(1) as UInt8)
        json["day"] = JSON(decoder.iterator(1) as UInt8)
        json["hour"] = JSON(decoder.iterator(1) as UInt8)
        json["minute"] = JSON(decoder.iterator(1) as UInt8)
        return json
    }
    /// 命令码=0x09(R)，读取分机记录数据
    func decode(record bytes: [UInt8]) -> JSON {
        var json = JSON()
        var decoder = UDPDecoder(data: bytes)
        let num = decoder.iterator(1) as UInt8
        json["bakeTimes"] = JSON(num)
        let total = decoder.iterator(2) as UInt16
        json["totalTimes"] = JSON(total)
        
        guard total > 0 else {
            return json
        }
        
        let record = decoder.iterator(2) as UInt16
        json["record"] = JSON(record)
        
        let record0 = decoder.iterator(1) as UInt8
        json["month"] = JSON(record0 >> 4)
        json["times"] = JSON(record0 & 0x0F)
        
        let record1 = decoder.iterator(2) as UInt16
        json["dry"] = JSON(Float(record1 >> 6) / 10.0)
        
        var year = UInt8(truncatingIfNeeded: record1 & 0x3F)
        
        let record2 = decoder.iterator(2) as UInt16
        json["wet"] = JSON(Float(record2 >> 6) / 10)
        year = year | UInt8(truncatingIfNeeded: record2 & 0x20)
        json["year"] = JSON(year)
        json["day"] = JSON(UInt8(truncatingIfNeeded: record2 & 0x1F))
        
        let record3 = decoder.iterator(2) as UInt16
        json["dryAim"] = JSON(Float(record3 >> 6) / 10)
        json["hour"] = JSON(UInt8(truncatingIfNeeded: record3 & 0x3F))
        
        let record4 = decoder.iterator(2) as UInt16
        json["wetAim"] = JSON(Float(record4 >> 6) / 10)
        json["minute"] = JSON(UInt8(truncatingIfNeeded: record4 & 0x3F))
        
        json["total"] = JSON(decoder.iterator(1) as UInt8)
        
        let record4_0 = decoder.iterator(1) as UInt8
        json["shed"] = JSON(record4_0 >> 7)
        json["tStatus"] = JSON(record4_0 & 0x1)
        
        let event = RecordEvent(rawValue: record4_0)
        json["events"] = JSON(event.des())
        
        let record5 = decoder.iterator(1) as UInt8
        json["type"] = JSON(record5 & 0x0F)
        
        return json
    }
    
    func decode(bind bytes: [UInt8]) -> JSON {
        var json = JSON()
        var decoder = UDPDecoder(data: bytes)
        let staus = decoder.iterator(1) as UInt8
        json["isbind"] = JSON(staus & 0x1)
        return json
    }
    // MARK: - JKS-II生物质燃烧机控制器的非通用命令
    /// 命令码=0x10(R)，读取分机生物质燃烧机状态
    func decode(burner_status bytes: [UInt8]) -> JSON {
        var json = JSON()
        var decoder = UDPDecoder(data: bytes)
        let num = decoder.iterator(1) as UInt8
        
        json["status"] = JSON(num)
        json["alarm"] = JSON(BurnerAlarm(rawValue: decoder.iterator(1)).des())
        json["fire"] = JSON(decoder.iterator(1) as UInt8)
        json["times"] = JSON(decoder.iterator(1) as UInt8)
        let thermocouple = decoder.iterator(2) as UInt16
        json["thermocouple"] = JSON(CGFloat(thermocouple) / 100.0)
        
        return json
    }
    /// 命令码=0x11(W),生物质燃烧机点火
    func decode(burner_fire bytes: [UInt8]) -> JSON {
        var json = JSON()
        var decoder = UDPDecoder(data: bytes)
        let num = decoder.iterator(1) as UInt8
        json["status"] = JSON(num)
        return json
    }
    /// 命令码=0x12(W),生物质燃烧机跳过点火
    func decode(burner_pass_fire bytes: [UInt8]) -> JSON {
        var json = JSON()
        var decoder = UDPDecoder(data: bytes)
        let num = decoder.iterator(1) as UInt8
        json["status"] = JSON(num)
        return json
    }
    /// 命令码=0x13(W),生物质燃烧机关机命令
    func decode(burner_off bytes: [UInt8]) -> JSON {
        var json = JSON()
        var decoder = UDPDecoder(data: bytes)
        let num = decoder.iterator(1) as UInt8
        json["status"] = JSON(num)
        return json
    }
}

extension UDPDevice {
    /// 设备命令编码
    func encode() -> [UInt8] {
        var datas = [UInt8]()
        
        switch order.sub {
        case .status: break
        case .realTime: break
        case .curves:
            datas = encodeCurves()
        case .curve:
            datas = encodeCurve()
        case .run:
            datas = encodeRun()
        case .curveCoding:
            datas = encodeCurveCoding()
        case .curveNum:
            datas = encodeCurveNum()
        case .shed:
            datas = encodeShed()
        case .time:
            datas = encodeTime()
        case .record:
            datas = encodeRecord()
        case .bind:
            datas = encodeBind()
        case .burner_status: break
        case .burner_fire: break
        case .burner_off: break
        case .burner_pass_fire: break
        default: break
        }
        var bytes = [order.rawValue] // 命令码
        bytes.append(UInt8(datas.count)) // 命令数据长度
        bytes.append(contentsOf: datas) //datas.size()
        
//        if let password = data["password"].string, order.sub < SubOrder.bindDevice {
//            if let pwds = password.psdBytes {
//                bytes.append(contentsOf: pwds) //密码【3】
//            }
//        }
        var sum = 0
        
        for byte in bytes {
            sum += Int(byte)
        }
        bytes.append(UInt8(truncatingIfNeeded: 0 - sum)) //校验和[1]
        return bytes
    }
    ///
    private func encodeCurves() -> [UInt8] {
        var codes = [UInt8]()
        
        codes.append(data["coding"].uInt8Value)
        
        if let curves = data["curves"].array {
            for _curves in curves {
                codes.append(_curves["dry"].uInt8Value)
                let wetF = _curves["wet"].floatValue
                let wetI = Int(wetF)
                let wet = wetF - Float(wetI) > 0 ? (UInt8(wetI) | 0x80) : UInt8(wetI)
                codes.append(wet)
                codes.append(_curves["up"].uInt8Value)
                codes.append(_curves["steady"].uInt8Value)
                codes.append(contentsOf: [0, 0])
            }
        }
        return codes
    }
    
    private func encodeCurve() -> [UInt8] {
        var codes = [UInt8]()
        codes.append(data["coding"].uInt8Value)
        codes.append(data["curveNum"].uInt8Value)
        let curve = data["curve"]
        
        if let dry      = curve["dry"].string,
            let wetF    = curve["wet"].string,
            let up      = curve["up"].int,
            let steady  = curve["steady"].int {
            codes.append(UInt8(truncatingIfNeeded: (Int(dry) ?? 0) & 0xFF))
            let wetFF = Float(wetF) ?? 0
            let wetI = Int(wetFF)
            let wet = wetFF - Float(wetI) > 0 ? (UInt8(wetI) | 0x80) : UInt8(wetI)
            codes.append(wet)
            codes.append(UInt8(truncatingIfNeeded: up & 0xFF))
            codes.append(UInt8(truncatingIfNeeded: steady & 0xFF))
            codes.append(contentsOf: [0, 0])
        }
        return codes
    }
    /// 命令码=0x04(W)，分机运行/停止控制
    private func encodeRun() -> [UInt8] {
        var codes = [UInt8]()
        let isRun = data["run"]
        codes.append(isRun.uInt8Value)
        return codes
    }
    /// 命令码=0x05(W)，选择分机烘烤曲线
    private func encodeCurveCoding() -> [UInt8] {
        var codes = [UInt8]()
        let coding = data["coding"]
        codes.append(coding.uInt8Value)
        return codes
    }
    /// 命令码=0x05(W)，选择分机烘烤曲线
    private func encodeCurveNum() -> [UInt8] {
        var codes = [UInt8]()
        let num = data["curveNum"]
        codes.append(num.uInt8Value)
        return codes
    }
    /// 命令码=0x07(W)，设置分机上/下棚
    private func encodeShed() -> [UInt8] {
        var codes = [UInt8]()
        let shed = data["shed"]
        codes.append(shed.uInt8Value)
        return codes
    }
    /// 命令码=0x08(RW)，读写分机烤次及日期时间
    private func encodeTime() -> [UInt8] {
        var codes = [UInt8]()
        
        if let bakeTimes = data["bakeTimes"].int  {
            codes.append(UInt8(bakeTimes & 0xFF))
        } else {
            return [UInt8]()
        }
        
        if let year = data["year"].int,
            let month = data["month"].int,
            let day = data["day"].int,
            let hour = data["hour"].int,
            let minute = data["minute"].int {
            codes.append(UInt8(truncatingIfNeeded: year & 0xFF))
            codes.append(UInt8(truncatingIfNeeded: month & 0xFF))
            codes.append(UInt8(truncatingIfNeeded: day & 0xFF))
            codes.append(UInt8(truncatingIfNeeded: hour & 0xFF))
            codes.append(UInt8(truncatingIfNeeded: minute & 0xFF))
        }
        return codes
    }
    /// 命令码=0x09(R)，读取分机记录数据
    private func encodeRecord() -> [UInt8] {
        let bakeTimes = data["bakeTimes"].uInt8Value
        let num = data["num"].intValue.bytes(limit: 2)
        var codes = [bakeTimes]
        codes.append(contentsOf: num)
        return codes
    }
    /// 命令码=0x0A(W)，远程绑定与解绑命令
    private func encodeBind() -> [UInt8] {
        let isbind = data["isbind"].boolValue
        let id = UInt16(truncatingIfNeeded: data["id"].intValue)
        let bind = (isbind ? 0x8000 : 0x0) | id
        let codes = [UInt8(truncatingIfNeeded: bind & 0xFF), UInt8(truncatingIfNeeded: (bind & 0xFF00) >> 8)]
        return codes
    }
}


