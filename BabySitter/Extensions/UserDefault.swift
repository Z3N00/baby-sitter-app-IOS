//
//  UserDefault.swift
//  CarRental
//
//  Created by 2022M3 on 19/01/22.
//

import Foundation


import Foundation

@propertyWrapper
struct UserDefault<T> {
    let key: String
    let defaultValue: T
    
    init(_ key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }
    
    var wrappedValue: T {
        get {
            return UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
        }
        set {
            UserDefaults.standard.set(newValue, forKey: key)
            UserDefaults.standard.synchronize()
        }
    }
}

struct UserDefaultsConfig {
    @UserDefault(UserDefaults.Keys.currentUser, defaultValue: false)
    static var currentUser: Bool
    
    @UserDefault(UserDefaults.Keys.authorization, defaultValue: false)
    static var isAuthorization: Bool
    
    @UserDefault(UserDefaults.Keys.appleLanguages, defaultValue: [""])
    static var appleLanguages: [String]

}
