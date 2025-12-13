//
//  QuitItem.swift
//  GoInto
//
//  Created by Hori,Masaki on 2017/04/14.
//  Copyright © 2017年 Hori,Masaki. All rights reserved.
//

import Cocoa
import Combine

class QuitItem: StatusItem {
    
    let menuItem = NSMenuItem()
    
    private var cancellalbes: [AnyCancellable] = []
    
    init() {
        
        let format = NSLocalizedString("Quit %@", comment: "Quit Menu Item")
        menuItem.title = String(format: format, AppDelegate.appName)
        menuItem
            .actionPublisher()
            .sink { _ in
                NSApplication.shared.terminate(nil)
            }
            .store(in: &cancellalbes)
        
    }
}
