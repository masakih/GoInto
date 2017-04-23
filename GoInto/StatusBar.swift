//
//  StatusBar.swift
//  GoInto
//
//  Created by Hori,Masaki on 2017/04/09.
//  Copyright © 2017年 Hori,Masaki. All rights reserved.
//

import Cocoa

final class StatusBar: NSObject {
    let myStatusBar = NSStatusBar.system().statusItem(withLength: NSSquareStatusItemLength)
    let menu = NSMenu()
    private(set) var items: [StatusItem] = []
    private(set) var recentItems = LimitedArray<FolderItem>(5)
    
    override init() {
        super.init()
        menu.delegate = self
        
        myStatusBar.menu = menu
        myStatusBar.button?.image = #imageLiteral(resourceName: "MenuIconTemplate")
        
        build()
    }
    
    private func build() {
        items.append(FolderItem(desktopURL()))
        items.append(FolderItem(picturesURL()))
        items.append(SeparatorItem())
        items.append(ChooseFolderItem(appendFolder))
        items.append(SeparatorItem())
        items.append(ImageTypeItem())
        items.append(SeparatorItem())
        items.append(QuitItem())
        
        items.reversed().forEach { $0.enter(menu) }
        
        UserDefaults.standard.recentURLs?.forEach(appendFolder)
        
        let currentLocation = Screenshot.shared.location
        if items
            .flatMap({ $0 as? FolderItem })
            .filter({ $0.url == currentLocation })
            .isEmpty {
            appendFolder(currentLocation)
        }
    }
    
    private func appendFolder(_ url: URL) {
        let newItem = FolderItem(url)
        newItem.enter(menu)
        newItem.set()
        recentItems.append(newItem)
        
        UserDefaults.standard.recentURLs = recentItems.map { $0.url }
    }
}

extension StatusBar: NSMenuDelegate {
    func menuWillOpen(_ menu: NSMenu) {
        let url = Screenshot.shared.location
        items
            .flatMap { $0 as? FolderItem }
            .forEach { $0.update(url) }
        recentItems.forEach { $0.update(url) }
        items
            .flatMap { $0 as? ImageTypeItem }
            .forEach { $0.update() }
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
