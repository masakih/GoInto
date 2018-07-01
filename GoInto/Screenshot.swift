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
        
        get { return screencaptureAttribute(.location).map { URL(fileURLWithPath: $0) } ?? desktopURL() }
        set { setScreencaptureAttribute(newValue.path, for: .location) }
    }
    var type: String {
        
        get { return screencaptureAttribute(.type) ?? "jpeg" }
        set { setScreencaptureAttribute(newValue, for: .type) }
    }
    
    @available(macOS, deprecated: 10.12)
    func apply() {
        
        let process = Process()
        process.launchPath = "/usr/bin/killall"
        process.arguments = ["SystemUIServer"]
        process.launch()
    }
    
    private func screencaptureAttribute(_ attr: Attrubute) -> String? {
        
        return UserDefaults(suiteName: "com.apple.screencapture")?
                .object(forKey: attr.rawValue) as? String
    }
    
    private func setScreencaptureAttribute(_ value: String, for attr: Attrubute) {
        
        UserDefaults(suiteName: "com.apple.screencapture")?
            .set(value, forKey: attr.rawValue)
    }
}
