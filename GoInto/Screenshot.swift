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
    
    var location: URL {
        get {
            guard let location =  screencaptureAttribute(.location)
                else { return desktopURL() }
            return URL(fileURLWithPath: location)
        }
        set {
            setScreencaptureAttribute(newValue.path, for: .location)
        }
    }
    var type: String {
        get {
            return screencaptureAttribute(.type) ?? "jpeg"
        }
        set {
            setScreencaptureAttribute(newValue, for: .type)
        }
    }
    
    @available(macOS, deprecated: 10.12)
    func apply() {
        let process = Process()
        process.launchPath = "/usr/bin/killall"
        process.arguments = ["SystemUIServer"]
        
        process.launch()
    }
    
    private func screencaptureAttribute(_ attr: Attrubute) -> String? {
        let process = Process()
        process.launchPath = "/usr/bin/defaults"
        process.arguments = ["read", "com.apple.screencapture", attr.rawValue]
        
        let pipe = Pipe()
        process.standardOutput = pipe
        
        process.launch()
        process.waitUntilExit()
        
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        guard let output = String(data: data, encoding: .utf8),
            let type = output.components(separatedBy: "\n").first,
            process.terminationStatus == 0
            else { return nil }
        return type
    }
    private func setScreencaptureAttribute(_ value: String, for attr: Attrubute) {
        let process = Process()
        process.launchPath = "/usr/bin/defaults"
        process.arguments = ["write", "com.apple.screencapture", attr.rawValue, value]
        
        process.launch()
        process.waitUntilExit()
        
        guard process.terminationStatus == 0
            else {
                print("Can not set location")
                return
        }
    }
}
