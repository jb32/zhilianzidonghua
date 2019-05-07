//
//  db.swift
//  Inteligence
//
//  Created by zzzl on 2018/10/17.
//  Copyright © 2018年 zzzl. All rights reserved.
//

import Foundation

extension String {
    class var token: String? {
        get {
            return UserDefaults.standard.string(forKey: "zzzl@token")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "zzzl@token")
            UserDefaults.standard.synchronize()
        }
    }
}
