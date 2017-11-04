//
//  ChooseFolderItem.swift
//  GoInto
//
//  Created by Hori,Masaki on 2017/04/14.
//  Copyright © 2017年 Hori,Masaki. All rights reserved.
//

import Cocoa

extension ActionListener {
    @IBAction func selectFolder(_ sender: Any?) {
        guard let owner = owner as? ChooseFolderItem else { return }
        let panel = NSOpenPanel()
        panel.canChooseDirectories = true
        panel.allowsMultipleSelection = false
        panel.canChooseFiles = false
        panel.canCreateDirectories = true
        panel.prompt = NSLocalizedString("Choose Folder", comment: "Choose Folder Open Panel Prompt")
        panel.title = NSLocalizedString("Choose Folder", comment: "Choose Folder Open Panel Title")
        panel.message = NSLocalizedString("Choose Folder for Save Screenshot", comment: "Choose Folder Open Panel Message")
        
        guard panel.runModal() == NSApplication.ModalResponse(NSFileHandlingPanelOKButton),
            let url = panel.directoryURL else { return }
        owner.urlSelector(url)
    }
}

class ChooseFolderItem: StatusItem {
    let menuItem = NSMenuItem()
    let urlSelector: (URL) -> Void
    private let listener = ActionListener()
    
    init(_ handler: @escaping ((URL) -> Void)) {
        urlSelector = handler
        menuItem.title = NSLocalizedString("Choose Folder", comment: "Choose Folder MenuItem")
        menuItem.action = #selector(ActionListener.selectFolder(_:))
        menuItem.target = listener
        listener.owner = self
    }
}
