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
    var items: [StatusItem] = []
    
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
        items.append(ChooseFolerItem(appendFolder))
        items.append(SeparatorItem())
        items.append(ImageTypeItem())
        items.append(SeparatorItem())
        items.append(QuitItem())
        
        items.reversed().forEach { $0.enter(menu) }
        
        let currentLocation = Screenshot.shared.location
        if currentLocation != picturesURL(),
            currentLocation != desktopURL() {
            let _ = folderItem(for: currentLocation)
        }
    }
    
    private func folderItem(for url: URL) -> FolderItem {
        if let item = items
            .flatMap({ $0 as? FolderItem })
            .filter({ $0.url == url })
            .first {
            return item
        }
        let new = FolderItem(url)
        new.enter(menu)
        new.menuItem.state = NSOnState
        items.append(new)
        return new
    }
    
    private func appendFolder(_ url: URL) {
        let newItem = FolderItem(url)
        newItem.enter(menu)
        newItem.set()
        items.append(newItem)
    }
}

extension StatusBar: NSMenuDelegate {
    func menuWillOpen(_ menu: NSMenu) {
        let url = Screenshot.shared.location
        items
            .flatMap { $0 as? FolderItem }
            .forEach { $0.update(url) }
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
