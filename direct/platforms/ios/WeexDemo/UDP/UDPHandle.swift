//
//  UDPHandle.swift
//  WeexDemo
//
//  Created by zzzl on 2019/1/9.
//  Copyright © 2019 zzzl. All rights reserved.
//

import Foundation
import SwiftyJSON

class UDPHandle {
    var command: UDPCommand?
    var order: Order
    var data: JSON?
    var status: Int?
    var mid: String?
    var isAlarm = false
    var alarmDes = ""
    
    init() {
        order = Order(rawValue: 2)!
    }
    
    init?(service data: Data) {
        var bytes = data.bytes
        let checks = bytes[0..<bytes.index(before: bytes.endIndex)]
        var sum = 0
        
        for byte in checks {
            sum += Int(byte)
        }
        /// 校验码
        let check = Int(truncatingIfNeeded: bytes.removeLast()) /// 校验码
        sum += check
        
        if UInt8(truncatingIfNeeded: sum) != 0 {
            return nil
        }
        
        guard let order = Order(rawValue: bytes.removeFirst()) else {
            return nil
        }
        self.order = order                                      /// 命令码
        self.status = Array(bytes[0..<2]).int/// 响应码
        bytes.removeSubrange(0..<2)
        
        let mid_len = Int(truncatingIfNeeded: bytes.removeFirst())
        
        if mid_len > 0 && bytes.count > mid_len {
            mid = Array(bytes[0..<mid_len]).str
            bytes.removeSubrange(0..<mid_len)
        }
        self.data = decode(bytes)
    }
    
    init(command: UDPCommand) {
        self.command = command
        order = command.order
        data = command.param.param
    }
}
//MARK: - decode 解码
extension UDPHandle {
    ///
    func decode(device _bytes: [UInt8]) -> JSON {
        return JSON()
    }
    /// 解码
    func decode(_ bytes: [UInt8]) -> JSON? {
        var json: JSON?
        
        if order.isService() {
            let datas = Data(bytes)
            
            if let base64 = GTMBase64.decode(datas),
                let data = try? base64.gunzipped(),
                let ajson = try? JSON(data: data) {
                json = ajson
            } else {
                json = JSON()
            }
        } else {
            let udpDevice = UDPDevice(bytes)
            json = udpDevice?.data
            isAlarm = udpDevice?.isAlarm ?? false
            alarmDes = udpDevice?.alarmDes ?? ""
        }
        return json
    }
    
    func getRsp() -> [String: Any]? {
        if let obj = data?.dictionaryObject {
            let rsp: [String: Any] = ["state": status ?? 0]
            return rsp.merging(obj) { (_, new) -> Any in
                return new
            }
        }
        return nil
    }
}
//MARK: - encode 编码
extension UDPHandle {
    /// 编码
    /// [order, `password`, length, [], sum]
    func encode() -> Data {
        guard let command = command else {
            return Data([UInt8]())
        }
        var bytes = [command.order.rawValue, 1] /// 1 标识 用于表示是移动端数据 0表示设备数据
        
        if let token = command.param.token {
            let tokens = token.bytes  /// 登录 token
            /// 数据长度的长度
            bytes.append(UInt8(truncatingIfNeeded: tokens.count.bytes().count))
            
            if tokens.count > 0 {
                /// 数据长度
                bytes.append(contentsOf: tokens.count.bytes())
                /// 数据
                bytes.append(contentsOf: tokens)
            }
        } else {
            bytes.append(0)
        }
        
        let uuids = command.param.uuid.bytes;   /// 设备 uuid
        bytes.append(UInt8(truncatingIfNeeded: uuids.count.bytes().count))
        
        if uuids.count > 0 {
            bytes.append(contentsOf: uuids.count.bytes())
            bytes.append(contentsOf: uuids)
        }
        
        if let mid = data!["mid"].string {
            bytes.append(UInt8(truncatingIfNeeded: mid.count))
            bytes.append(contentsOf: mid.bytes)
        } else {
            bytes.append(0)
        }
        var datas: [UInt8]
        
        if order.isService() {
            datas = encodeService() /// 发往服务器的数据
        } else {
            datas = UDPDevice(order: order, data: data!).encode()  /// 服务器转发的数据
        }
        bytes.append(contentsOf: datas)
        /// TODO: 校验
        var sum = 0
        
        for byte in bytes {
            sum += Int(truncatingIfNeeded: byte)
        }
        let check = UInt8(truncatingIfNeeded: 0 - sum)
        bytes.append(check)
        
        return Data(bytes)
    }
    /// 服务器命令编码
    private func encodeService() -> [UInt8] {
        if let data = encode(service: data!) {
            do {
                let gzip = try data.gzipped()
                let base64 = GTMBase64.encode(gzip)
                return base64?.bytes ?? [UInt8]()
            } catch {
                print(msg: error)
            }
        }
        return [UInt8]()
    }
    /// 命令编码
    /// ["param": [:], "uuid": ""]
    /// - Parameters:
    ///   - param: 参数
    /// - Returns: 编码结果
    private func encode(service param: JSON) -> Data? {
        var params = param
        
        if let password = param["password"].string {
            params["password"] = JSON(password.md5())
        }
        
        if let card = param["card"].string {
            params["card"] = JSON(card.md5())
        }
        return try? params.rawData()
    }
}

