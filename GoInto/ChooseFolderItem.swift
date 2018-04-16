//
//  ChooseFolderItem.swift
//  GoInto
//
//  Created by Hori,Masaki on 2017/04/14.
//  Copyright © 2017年 Hori,Masaki. All rights reserved.
//

import Cocoa

class ChooseFolderItem: StatusItem {
    
    let menuItem = NSMenuItem()
    let urlSelector: (URL) -> Void
    
    init(_ handler: @escaping ((URL) -> Void)) {
        
        urlSelector = handler
        menuItem.title = NSLocalizedString("Choose Folder", comment: "Choose Folder MenuItem")
        menuItem.action = #selector(selectFolder(_:))
        menuItem.target = self
    }
    
    @IBAction func selectFolder(_ sender: Any?) {
        
        let panel = NSOpenPanel()
        panel.canChooseDirectories = true
        panel.allowsMultipleSelection = false
        panel.canChooseFiles = false
        panel.canCreateDirectories = true
        panel.prompt = NSLocalizedString("Choose Folder", comment: "Choose Folder Open Panel Prompt")
        panel.title = NSLocalizedString("Choose Folder", comment: "Choose Folder Open Panel Title")
        panel.message = NSLocalizedString("Choose Folder for Save Screenshot", comment: "Choose Folder Open Panel Message")
        
        NSApplication.shared.activate(ignoringOtherApps: true)
        guard panel.runModal() == NSApplication.ModalResponse(NSFileHandlingPanelOKButton),
            let url = panel.directoryURL else {
                
                return
        }
        urlSelector(url)
    }
}
