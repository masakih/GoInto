//
//  Screenshot.swift
//  GoInto
//
//  Created by Hori,Masaki on 2017/04/16.
//  Copyright © 2017年 Hori,Masaki. All rights reserved.
//

import Foundation

class Screenshot {
    
    private enum Attrubute: String {
        
        case location = "location"
        
        case type = "type"
    }
    
    static let shared = Screenshot()
    
    private init() {}
    
    var location: URL {
        
        get {
            self[.location]
                .map {
                    URL(fileURLWithPath: ($0 as NSString).expandingTildeInPath)
                } ?? desktopURL()
        }
         set { self[.location] = newValue.path }

    }
    var type: String {
        
        get { return self[.type] ?? "jpeg" }
        set { self[.type] = newValue }
    }
    
    @available(macOS, deprecated: 10.12)
    func apply() {
        
        let process = Process()
        process.launchPath = "/usr/bin/killall"
        process.arguments = ["SystemUIServer"]
        process.launch()
    }
    
    private subscript(_ attr: Attrubute) -> String? {
        get { 
            UserDefaults(suiteName: "com.apple.screencapture")?
                .object(forKey: attr.rawValue) as? String
        }
        set { 
            UserDefaults(suiteName: "com.apple.screencapture")?
                .set(newValue, forKey: attr.rawValue)

            if attr == .location {
                UserDefaults(suiteName: "com.apple.screencapture")?
                    .set("file", forKey: "target")
        }
    }
}
