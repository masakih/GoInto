//
//  StatusBar.swift
//  GoInto
//
//  Created by Hori,Masaki on 2017/04/09.
//  Copyright © 2017年 Hori,Masaki. All rights reserved.
//

import Cocoa

final class StatusBar: NSObject {
    let myStatusBar = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
    let menu = NSMenu()
    private(set) var items: [StatusItem] = []
    private(set) var recentItems = LimitedArray<FolderItem>(5) {
        didSet { UserDefaults.standard.recentURLs = recentItems.map { $0.url } }
    }
    
    override init() {
        super.init()
        menu.delegate = self
        
        myStatusBar.menu = menu
        myStatusBar.button?.image = #imageLiteral(resourceName: "MenuIconTemplate")
        
        build()
    }
    
    private func build() {
        items = [
            FolderItem(desktopURL()),
            FolderItem(picturesURL()),
            SeparatorItem(),
            ChooseFolderItem(appendAndChooseFolder),
            SeparatorItem(),
            ImageTypeItem(),
            SeparatorItem(),
            QuitItem()
        ]
        
        items.reversed().forEach { $0.enter(menu) }
        
        UserDefaults.standard.recentURLs?.forEach(appendFolder)
        
        appendFolder(Screenshot.shared.location)
    }
    
    private func newFolderItem(_ url: URL) -> FolderItem? {
        
        guard url != desktopURL() else { return nil }
        guard url != picturesURL() else { return nil }
        
        let newItem = FolderItem(url)
        recentItems.append(newItem)
        newItem.enter(menu)
        return newItem
    }
    
    private func appendFolder(_ url: URL) {
        _ = newFolderItem(url)
    }
    
    private func appendAndChooseFolder(_ url: URL) {
        newFolderItem(url)?.set()
    }
}

extension StatusBar: NSMenuDelegate {
    func menuWillOpen(_ menu: NSMenu) {
        let url = Screenshot.shared.location
        recentItems.forEach { $0.update(url) }
        items.forEach { item in
            switch item {
            case let f as FolderItem: f.update(url)
            case let i as ImageTypeItem: i.update()
            default: ()
            }
        }
    }
}


fileprivate func picturesURL() -> URL {
    return FileManager
        .default
        .urls(for: .picturesDirectory,
              in: .userDomainMask).last ?? URL(fileURLWithPath: NSHomeDirectory())
}

func desktopURL() -> URL {
    return FileManager
        .default
        .urls(for: .desktopDirectory,
              in: .userDomainMask).last ?? URL(fileURLWithPath: NSHomeDirectory())
}
