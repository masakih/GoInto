//
//  UserDefaultsExtension.swift
//  GoInto
//
//  Created by Hori,Masaki on 2017/04/23.
//  Copyright © 2017年 Hori,Masaki. All rights reserved.
//

import Foundation

extension UserDefaults {
    
    func set(archived: Any?, forKey: String) {
        
        if let object = archived {
            
            let data = NSKeyedArchiver.archivedData(withRootObject: object)
            set(data, forKey: forKey)
            
        } else {
            
            set(nil, forKey: forKey)
        }
    }
    
    func unarchiveObject(forKey: String) -> Any? {
        
        if let data = object(forKey: forKey) as? Data {
            
            return NSKeyedUnarchiver.unarchiveObject(with: data)
        }
        
        return nil
    }
    
    var recentURLs: [URL]? {
        
        get { return unarchiveObject(forKey: "recentURLs") as? [URL] }
        set { set(archived: newValue, forKey: "recentURLs") }
    }
}
