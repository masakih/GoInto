//
//  FolderItem.swift
//  GoInto
//
//  Created by Hori,Masaki on 2017/04/14.
//  Copyright © 2017年 Hori,Masaki. All rights reserved.
//

import Cocoa

extension Selector {
    static let changeFolder = #selector(FolderItem.changeFolder(_:))
}

class FolderItem: StatusItem {
    let url: URL
    let menuItem = NSMenuItem()
    
    init(_ url: URL) {
        self.url = url
        
        if let either = try? url.resourceValues(forKeys: [.localizedNameKey]),
            let name = either.localizedName {
             menuItem.title = name
        } else {
            menuItem.title = FileManager.default.displayName(atPath: url.path)
        }
        
        let work = NSWorkspace.shared()
        menuItem.image = fitSize(work.icon(forFile: url.path))
        
        menuItem.action = .changeFolder
        menuItem.target = self
    }
    
    @IBAction func changeFolder(_ sender: Any?) {
        set()
    }
    
    func set() {
        DispatchQueue(label: "Launch defaults").async {
            let location = self.url.path
            let task = Process()
            task.launchPath = "/usr/bin/defaults"
            task.arguments = ["write", "com.apple.screencapture", "location", location]
            
            task.launch()
            task.waitUntilExit()
            
            guard task.terminationStatus == 0
                else {
                    print("Can not set location")
                    return
            }
        }
    }
    
    func update(_ url: URL) {
        if self.url == url {
            menuItem.state = NSOnState
        } else {
            menuItem.state = NSOffState
        }
    }
}

func fitSize(_ image: NSImage) -> NSImage {
    let fitSize: CGFloat = 19
    let size = image.size
    guard size.width > fitSize else { return image }
    let ratio = fitSize / size.width
    let newSize = NSSize(width: size.width * ratio, height: size.height * ratio)
    image.resizingMode = .stretch
    image.size = newSize
    return image
}
