//
//  UUID.swift
//  Inteligence
//
//  Created by zzzl on 2018/10/15.
//  Copyright © 2018年 zzzl. All rights reserved.
//

import Foundation


class UUID {
    private static let bundleId = Bundle.main.bundleIdentifier ?? ""
    
    class func string() -> String {
        let uuid = load(bundleId)
        
        if uuid == nil || uuid!.isEmpty {
            let puuid = CFUUIDCreate(nil)
            let uuidString = CFUUIDCreateString(nil, puuid)
            if let result = CFStringCreateCopy(nil, uuidString) {
                save(bundleId, data: result)
                return load(bundleId) ?? ""
            }
        }
        return uuid ?? ""
    }
    
    private class func save(_ bundleId: String, data: CFString) {
        var keychain = keychainQuery(bundleId)
        SecItemDelete(keychain as CFDictionary)
        keychain[kSecValueData] = NSKeyedArchiver.archivedData(withRootObject: data)
        var err: CFTypeRef?
        SecItemAdd(keychain as CFDictionary, &err)
    }
    
    private class func load(_ bundleId: String) -> String? {
        var keychain = keychainQuery(bundleId)
        keychain[kSecReturnData] = kCFBooleanTrue
        keychain[kSecMatchLimit] = kSecMatchLimitOne
        
        var keyData: CFTypeRef?
        let osstaus = SecItemCopyMatching(keychain as CFDictionary, &keyData)
        
        if osstaus == noErr, let typeData = keyData, let data = typeData as? Data {
            let result = NSKeyedUnarchiver.unarchiveObject(with: data) as? String
            return result
        }
        return nil
    }
    
    private class func keychainQuery(_ bundleId: String) -> [CFString : AnyHashable] {
        let dic = [kSecClass: kSecClassInternetPassword,
                   kSecAttrServer: (bundleId as CFString),
                   kSecAttrAccount: (bundleId as CFString)] as [CFString : AnyHashable]
        return dic
    }
}
