//
//  ChooseFolerItem.swift
//  GoInto
//
//  Created by Hori,Masaki on 2017/04/14.
//  Copyright © 2017年 Hori,Masaki. All rights reserved.
//

import Cocoa

extension ActionListener {
    @IBAction func selectFolder(_ sender: Any?) {
        guard let owner = owner as? ChooseFolerItem else { return }
        let panel = NSOpenPanel()
        panel.canChooseDirectories = true
        panel.allowsMultipleSelection = false
        panel.canChooseFiles = false
        panel.canCreateDirectories = true
        
        panel.prompt = NSLocalizedString("Choose Folder", comment: "Choose Folder Open Panel Prompt")
        panel.title = NSLocalizedString("Choose Folder", comment: "Choose Folder Open Panel Title")
        panel.message = NSLocalizedString("Choose Folder for Save Screenshot", comment: "Choose Folder Open Panel Message")
        
        guard panel.runModal() == NSFileHandlingPanelOKButton,
            let url = panel.directoryURL else { return }
        owner.urlSelector(url)
    }
}
extension Selector {
    static let selectFolder = #selector(ActionListener.selectFolder(_:))
}

class ChooseFolerItem: StatusItem {
    let menuItem = NSMenuItem()
    let urlSelector: (URL) -> Void
    let listener = ActionListener()
    
    init(_ handler: @escaping ((URL) -> Void)) {
        urlSelector = handler
        menuItem.title = NSLocalizedString("Choose Folder", comment: "Choose Folder MenuItem")
        menuItem.action = .selectFolder
        menuItem.target = listener
        listener.owner = self
    }
}
