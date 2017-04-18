//
//  FolderItem.swift
//  GoInto
//
//  Created by Hori,Masaki on 2017/04/14.
//  Copyright © 2017年 Hori,Masaki. All rights reserved.
//

import Cocoa

extension ActionListener {
    @IBAction func changeFolder(_ sender: Any?) {
        guard let owner = owner as? FolderItem else { return }
        owner.set()
    }
}
extension Selector {
    static let changeFolder = #selector(ActionListener.changeFolder(_:))
}

class FolderItem: StatusItem {
    let url: URL
    let menuItem = NSMenuItem()
    let listener = ActionListener()
    
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
        menuItem.target = listener
        listener.owner = self
    }
    
    func set() {
        let newUrl = url
        DispatchQueue(label: "Launch defaults").async {
            Screenshot.shared.location = newUrl
            if #available(macOS 10.12, *) {
                return
            } else {
                Screenshot.shared.apply()
            }
        }
    }
    
    func update(_ url: URL) {
        menuItem.state = (self.url == url ? NSOnState : NSOffState)
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
