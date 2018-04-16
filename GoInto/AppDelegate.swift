//
//  AppDelegate.swift
//  GoInto
//
//  Created by Hori,Masaki on 2017/04/09.
//  Copyright © 2017年 Hori,Masaki. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    let statusBar = StatusBar()
    
    class var appName: String {
        
        guard let dict = Bundle.main.localizedInfoDictionary,
            let name = dict["CFBundleDisplayName"] as? String else {
                
                return "GO into"
        }
        return name
    }
}
