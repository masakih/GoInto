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
    private let supportTypes = loadImageTypes()
    private let listener = ActionListener()
    
    init() {
        listener.owner = self
        
        menuItem.title = NSLocalizedString("Image Type", comment: "Image Type MenuItem")
        
        let ws = NSWorkspace.shared()
        menuItem.submenu = NSMenu()
        
        supportTypes
            .filter { ws.localizedDescription(forType: $0) != nil }
            .map {
                let item = NSMenuItem()
                item.title = ws.localizedDescription(forType: $0) ?? "Never Use Default Value"
                item.action = .selectType
                item.target = listener
                item.representedObject = ws.preferredFilenameExtension(forType: $0)
                return item
            }
            .forEach { menuItem.submenu?.addItem($0) }
    }
    
    func update() {
        let current = Screenshot.shared.type
        menuItem.submenu?.items.forEach {
            if let type = $0.representedObject as? String,
                type == current {
                $0.state = NSOnState
            } else {
                $0.state = NSOffState
            }
        }
    }
    
    fileprivate func set(_ typeName: String) {
        DispatchQueue(label: "Launch defaults").async {
            Screenshot.shared.type = typeName
        }
    }
}
