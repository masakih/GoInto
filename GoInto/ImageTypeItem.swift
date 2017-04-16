//
//  ImageTypeItem.swift
//  GoInto
//
//  Created by Hori,Masaki on 2017/04/15.
//  Copyright © 2017年 Hori,Masaki. All rights reserved.
//

import Cocoa

extension ActionListener {
    @IBAction func selectType(_ sender: Any?) {
        guard let owner = owner as? ImageTypeItem,
            let item = sender as? NSMenuItem,
            let typeName = item.representedObject as? String
            else { return }
        owner.set(typeName)
    }
}
extension Selector {
    static let selectType = #selector(ActionListener.selectType(_:))
}

private func loadImageTypes() -> [String] {
    guard let url = Bundle.main.url(forResource: "ImageType", withExtension: "plist"),
        let array = NSArray(contentsOf: url)
        else { return [] }
    return array as? [String] ?? []
}

class ImageTypeItem: StatusItem {
    let menuItem = NSMenuItem()
    let supportTypes = loadImageTypes()
    let listener = ActionListener()
    
    init() {
        listener.owner = self
        
        menuItem.title = NSLocalizedString("Image Type", comment: "Image Type MenuItem")
        
        let ws = NSWorkspace.shared()
        menuItem.submenu = NSMenu()
        
        supportTypes
            .filter { ws.localizedDescription(forType: $0) != nil }
            .map {
                let item = NSMenuItem()
                item.title = ws.localizedDescription(forType: $0) ?? "H O G E"
                item.action = .selectType
                item.target = listener
                item.representedObject = ws.preferredFilenameExtension(forType: $0)
                return item
            }
            .forEach { menuItem.submenu?.addItem($0) }
        
    }
    
    func update() {
        let current = currentType() ?? "jpeg"
        menuItem.submenu?.items.forEach {
            if let type = $0.representedObject as? String,
                type == current {
                $0.state = NSOnState
            } else {
                $0.state = NSOffState
            }
        }
    }
    
    func currentType() -> String? {
        let task = Process()
        task.launchPath = "/usr/bin/defaults"
        task.arguments = ["read", "com.apple.screencapture", "type"]
        
        let pipe = Pipe()
        task.standardOutput = pipe
        
        task.launch()
        task.waitUntilExit()
        
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        guard let output = String(data: data, encoding: .utf8),
            let type = output.components(separatedBy: "\n").first,
            task.terminationStatus == 0
            else { return nil }
        return type
    }
    
    fileprivate func set(_ typeName: String) {
        DispatchQueue(label: "Launch defaults").async {
            let task = Process()
            task.launchPath = "/usr/bin/defaults"
            task.arguments = ["write", "com.apple.screencapture", "type", typeName]
            
            task.launch()
            task.waitUntilExit()
            
            guard task.terminationStatus == 0
                else {
                    print("Can not set type")
                    return
            }
        }
    }
}
