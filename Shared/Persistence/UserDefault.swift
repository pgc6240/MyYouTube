//
//  UserDefault.swift
//  MyYouTube
//
//  Created by pgc6240 on 07.05.2021.
//

import Foundation

@propertyWrapper
struct UserDefault<T> {
    
    var userDefaults: UserDefaults = .standard
    let key: String
    let defaultValue: T
    
    var wrappedValue: T {
        get {
            guard let data = userDefaults.data(forKey: key) else { return defaultValue }
            let object = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? T
            return object ?? defaultValue
        }
        set {
            let data = try? NSKeyedArchiver.archivedData(withRootObject: newValue, requiringSecureCoding: false)
            userDefaults.set(data, forKey: key)
        }
    }
}


extension UserDefaults {
    static let myYouTube = UserDefaults(suiteName: "group.com.pgc6240.MyYouTube")!
}
