//
//  UserDefaultsExtension.swift
//  GoInto
//
//  Created by Hori,Masaki on 2017/04/23.
//  Copyright © 2017年 Hori,Masaki. All rights reserved.
//

import Foundation

extension UserDefaults {
    var recentFolders: LimitedArray<FolderItem>? {
        get {
            guard let data = object(forKey: "recentFolders") as? Data,
                let serialized: LimitedArray<FolderItem> = LimitedArraySerializer.deserialize(data)
                else { return nil }
            return serialized
        }
        set {
            let data = newValue.map { LimitedArraySerializer.seirialize($0) }
            set(data, forKey: "recentFolders")
        }
    }
}
