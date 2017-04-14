//
//  ChooseFolerItem.swift
//  GoInto
//
//  Created by Hori,Masaki on 2017/04/14.
//  Copyright © 2017年 Hori,Masaki. All rights reserved.
//

import Cocoa

extension Selector {
    static let selectFolder = #selector(ChooseFolerItem.selectFolder(_:))
}

class ChooseFolerItem: StatusItem {
    let menuItem = NSMenuItem()
    let urlSelector: (URL) -> Void
    
    init(_ handler: @escaping ((URL) -> Void)) {
        urlSelector = handler
        menuItem.title = "Choose Folder"
        menuItem.action = .selectFolder
        menuItem.target = self
    }
    
    @IBAction func selectFolder(_ sender: Any?) {
        let panel = NSOpenPanel()
        panel.canChooseDirectories = true
        panel.allowsMultipleSelection = false
        panel.canChooseFiles = false
        panel.canCreateDirectories = true
        
        panel.prompt = "Choose Folder"
        panel.title = "Choose Folder"
        panel.message = "Choose Folder for Save Screenshot"
        
        guard panel.runModal() == NSFileHandlingPanelOKButton,
            let url = panel.directoryURL else { return }
        urlSelector(url)
    }
    
    func validateMenuItem(_ menuItem: NSMenuItem) -> Bool {
        return true
    }
}
