//
//  EasyLink.swift
//  WeexDemo
//
//  Created by zzzl on 2018/11/27.
//  Copyright © 2018 zzzl. All rights reserved.
//

import Foundation
import Reachability

extension WIFILink {
    
    private struct Key {
        static var wifi: Reachability?
    }
    
    private var wifiReachability: Reachability? {
        get {
            return objc_getAssociatedObject(self, &Key.wifi) as? Reachability
        }
        set {
            objc_setAssociatedObject(self, &Key.wifi, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    @objc func start(_ callback: @escaping WXModuleKeepAliveCallback) {
        easylinkConfig = EASYLINK(forDebug: true, withDelegate: self)
        ssidback = callback
        
        wifiReachability = Reachability()
        try? wifiReachability?.startNotifier()
        wifiReachability?.notificationCenter.addObserver(self, selector: #selector(wifiStatusChanged(_:)), name: .reachabilityChanged, object: nil)
        wifiReachability?.notificationCenter.addObserver(self, selector: #selector(appEnterInforground(_:)), name: UIApplication.didBecomeActiveNotification, object: nil)
        let ssid = EASYLINK.ssidForConnectedNetwork()
        ssidback(ssid, false)
    }
    
    @objc func connect(_ info: [String: AnyHashable], _ callback: @escaping WXModuleKeepAliveCallback) {
        resultback = callback
        guard let ssid = EASYLINK.ssidDataForConnectedNetwork() else {
            resultback(["state": 200, "msg": "您的设备未连接到WiFi"], true)
            return
        }
        guard let password = info["password"] as? String else {
            resultback(["state": 201, "msg": "请输入密码"], true)
            return
        }
        let config = [KEY_SSID: ssid, KEY_PASSWORD: password, KEY_DHCP: 1] as [String : Any]
        easylinkConfig.prepareEasyLink(config, info: nil, mode: EASYLINK_AWS)
        easylinkConfig.transmitSettings()
    }
    
    @objc func dicconnect(_ callback: @escaping WXModuleKeepAliveCallback) {
        resultback = callback
    }
    
    @objc func stop() {
        easylinkConfig.stopTransmitting()
        easylinkConfig.unInit()
    }
    
    @objc private func wifiStatusChanged(_ notify: Notification) {
        
        if wifiReachability?.connection == .wifi, let ssid = EASYLINK.ssidForConnectedNetwork(), !ssid.hasPrefix("EasyLink_") && !easylinkConfig.softAPSending {
            ssidback(ssid, true)
        }
    }
    
    @objc private func appEnterInforground(_ notify: Notification) {
        if wifiReachability?.connection == .wifi, let ssid = EASYLINK.ssidForConnectedNetwork(), !ssid.hasPrefix("EasyLink_") && !easylinkConfig.softAPSending {
            ssidback(ssid, true)
        }
    }
}

extension WIFILink: EasyLinkFTCDelegate {
    public func onFound(byFTC client: NSNumber!, withConfiguration configDict: [AnyHashable : Any]!) {
        easylinkConfig.configFTCClient(client, withConfiguration: configDict)
        easylinkConfig.stopTransmitting()
        resultback(["state": 201, "msg": "连接失败"], true)
    }
    
    public func onFound(_ client: NSNumber!, withName name: String!, mataData mataDataDict: [AnyHashable : Any]!) {
        easylinkConfig.stopTransmitting()
        resultback(["state": 200, "msg": "连接成功"], true)
    }
    
    public func onDisconnect(fromFTC client: NSNumber!, withError err: Bool) {
        easylinkConfig.stopTransmitting()
        resultback(["state": 201, "msg": "已断开连接"], true)
    }
}
