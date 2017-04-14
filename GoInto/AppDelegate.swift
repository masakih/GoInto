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
    
    var statusBar: StatusBar?
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        statusBar = StatusBar()
    }
}
