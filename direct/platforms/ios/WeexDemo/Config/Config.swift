//
//  Config.swift
//  Inteligence
//
//  Created by zzzl on 2018/10/8.
//  Copyright © 2018年 zzzl. All rights reserved.
//

import Foundation
import Ruler
import AVFoundation
import UserNotifications

func print<T>(file: String = #file, method: String = #function, line: Int = #line, msg: T) -> Void {
    #if DEBUG
    var str = ""
    dump(msg, to: &str)
    let fileName = file.components(separatedBy: "/").last
    
    print("\(fileName!)[\(method)][\(line)][\(Date())]: \n\(str)")
    #endif
}

extension String {
    
    static var localhosts: [String] {
        var addresses = [String]()
        
        var ifaddr : UnsafeMutablePointer<ifaddrs>? = nil
        
        if getifaddrs(&ifaddr) == 0 {
            var ptr = ifaddr
            
            while ptr != nil {
                let flags = Int32(ptr!.pointee.ifa_flags)
                var addr = ptr?.pointee.ifa_addr.pointee
                
                if (flags & (IFF_UP | IFF_RUNNING | IFF_LOOPBACK)) == (IFF_UP | IFF_RUNNING) {
                    
                    if addr?.sa_family == UInt8(AF_INET) || addr?.sa_family == UInt8(AF_INET6) {
                        var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                        
                        if (getnameinfo(&addr!, socklen_t(addr!.sa_len), &hostname, socklen_t(hostname.count), nil, socklen_t(0), NI_NUMERICHOST) == 0) {
                            
                            if let address = String(validatingUTF8:hostname) {
                                addresses.append(address)
                            }
                        }
                    }
                }
                ptr = ptr!.pointee.ifa_next
            }
            freeifaddrs(ifaddr)
        }
        return addresses
    }
    
    static var host: String {
//        return "localhost"
        return "47.105.55.16"
    }
    
    static var uuid: String {
        return UUID.string()
    }
}

extension UInt16 {
    static var port: UInt16 {
        return 59999
    }
}

extension CGFloat {
    static var nav: CGFloat {
        if UIApplication.shared.statusBarOrientation == .landscapeLeft || UIApplication.shared.statusBarOrientation == .landscapeRight {
            return CGFloat(Ruler.iPhoneVertical(32, 32, 32, 32, 44, 44).value)
        }
        return CGFloat(Ruler.iPhoneVertical(64, 64, 64, 64, 88, 88).value)
    }
    
    static var tab: CGFloat {
        if UIApplication.shared.statusBarOrientation == .landscapeLeft || UIApplication.shared.statusBarOrientation == .landscapeRight {
            return CGFloat(Ruler.iPhoneVertical(32, 32, 32, 32, 70, 70).value)
        }
        return CGFloat(Ruler.iPhoneVertical(49, 49, 49, 49, 49 + 34, 49 + 34).value)
    }
    
    static var h_nav_tab: CGFloat {
        return UIScreen.main.bounds.height - nav - tab
    }
    
    static var h_nav: CGFloat {
        return UIScreen.main.bounds.height - nav
    }
    
    static var h: CGFloat {
        return UIScreen.main.bounds.height
    }
    
    static var w: CGFloat {
        return UIScreen.main.bounds.width
    }
}

extension Notification.Name {
    static let networkRecovery = Notification.Name("networkRecovery")
    static let refreshInstance = Notification.Name("RefreshInstance")
}

extension UIColor {
    class var random: UIColor{
        get {
            let red = CGFloat(arc4random() % 256) / 255.0
            let green = CGFloat(arc4random() % 256) / 255.0
            let blue = CGFloat(arc4random() % 256) / 255.0
            return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
        }
    }
}

class Config {
    #if TARGET_IPHONE_SIMULATOR
    static let weex_host = "127.0.0.1"
    #else
    static let weex_host = ""
    #endif
    static let weex_url: (String) -> String = {
        return "http://\(weex_host):12580/\($0)"
    }
    
    static let home_url: String = {
        return "http://\(weex_host):8080/dist/index.js"
    }()
    static let bundle_url: String = {
        return "file://\(Bundle.main.bundlePath)/bundlejs/index.js"
    }()
    static let uitest_home_url: String = {
        return "http://test?_wx_tpl=http://localhost:12580/test/build/TC__Home.js"
    }()
    
    class func all() {
        weex()
        udp()
        registerLocalPush()
    }
    
    class func weex() {
        
        WXAppConfiguration.setAppGroup("Inteligence")
        WXAppConfiguration.setAppName("Inteligence")
        WXAppConfiguration.setAppVersion("1.0.0")
        WXSDKEngine.initSDKEnvironment()
        WXLog.setLogLevel(.WXLogLevelLog)
        
        WXSDKEngine.registerModule("\(UDP.self)", with: UDP.self)
        WXSDKEngine.registerModule("\(ScanCode.self)", with: ScanCode.self)
//        WXSDKEngine.registerModule("\(HUD.self)", with: HUD.self)
        WXSDKEngine.registerModule("\(UserInfoModule.self)", with: UserInfoModule.self)
        WXSDKEngine.registerModule("\(WIFILink.self)", with: WIFILink.self)

        WXSDKEngine.registerHandler(ImageHandle(), with: WXImgLoaderProtocol.self)
        WXSDKEngine.registerHandler(NavigationHandle(), with: WXNavigationProtocol.self)
        
//        WXDevTool.setDebug(true)
//        WXDevTool.launchDebug(withUrl: "ws://169.254.181.48:8088/debugProxy/native")
    }
    
    class func udp() {
        UDPManage.share.create()
    }
}

extension Config {
    class func registerLocalPush() {
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (accepted, err) in
                if !accepted {
                    let alert = UIAlertController(title: nil, message: "请开启通知以便接收报警信息", preferredStyle: .alert)
                    UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
                }
            }
        } else {
            let localNotify = UILocalNotification()
            UIApplication.shared.scheduleLocalNotification(localNotify)
            let settings = UIUserNotificationSettings(types: [.sound, .alert, .badge], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
        }
    }
    
    class func pushLocalNotify(_ body: String) {
        if #available(iOS 10.0, *) {
            let content = UNMutableNotificationContent()
            content.title = "警告"
            content.body = body
            content.sound = .default
            let request = UNNotificationRequest(identifier: "notify", content: content, trigger: nil)
            UNUserNotificationCenter.current().add(request) { (err) in
                
            }
        } else {
            let localNotify = UILocalNotification()
            localNotify.alertTitle = "警告"
            localNotify.alertBody = body
            localNotify.applicationIconBadgeNumber = 0
            localNotify.soundName = UILocalNotificationDefaultSoundName
            UIApplication.shared.presentLocalNotificationNow(localNotify)
        }
    }
}

extension Config {
    
    class func sound(_ soundID: inout SystemSoundID) {
        let alarm = Bundle.main.path(forResource: "alarm", ofType: "mp3")
        guard let urlSound = URL(string: alarm ?? "") else { return }
        
        AudioServicesCreateSystemSoundID(urlSound as CFURL, &soundID)
    }
    
    class func playSound(_ soundID: SystemSoundID, isFinish: ((Bool) -> Void)?) {
        
        AudioServicesPlaySystemSoundWithCompletion(soundID) {
            isFinish?(true)
        }
    }
    
}
