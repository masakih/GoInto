//
//  QuitItem.swift
//  GoInto
//
//  Created by Hori,Masaki on 2017/04/14.
//  Copyright © 2017年 Hori,Masaki. All rights reserved.
//

import Cocoa

extension Selector {
    static let quit = #selector(QuitItem.quit(_:))
}

class QuitItem: StatusItem {
    let menuItem = NSMenuItem()
    init() {
        menuItem.title = "Quit Go into"
        menuItem.action = .quit
        menuItem.target = self
    }
    
    @IBAction func quit(_ sender: Any?) {
        NSApplication.shared().terminate(nil)
    }
}
