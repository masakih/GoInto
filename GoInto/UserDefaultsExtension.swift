//
//  UserDefaultsExtension.swift
//  GoInto
//
//  Created by Hori,Masaki on 2017/04/23.
//  Copyright © 2017年 Hori,Masaki. All rights reserved.
//

import Foundation

extension UserDefaults {
    
    enum CustomKey: String {
        
        case recentURLs
    }
    
    func set<T: Encodable>(encodedJSON value: T?, forKey key: CustomKey) {
        
        guard let value, let data = try? JSONEncoder().encode(value) else {
            
            set(nil, forKey: key.rawValue)
            return
        }
        
        set(data, forKey: key.rawValue)
        
    }
    
    func decodedJSON<T: Decodable>(_ type: T.Type, forKey key: CustomKey) -> T? {
        
        guard let data = object(forKey: key.rawValue) as? Data else {
            
            return nil
        }
        
        return try? JSONDecoder().decode(type, from: data)
    }
    
    var recentURLs: [URL]? {
        
        get { decodedJSON([URL].self, forKey: .recentURLs) }
        set { set(encodedJSON: newValue, forKey: .recentURLs) }
    }
}
