//
//  ImageTypeItem.swift
//  GoInto
//
//  Created by Hori,Masaki on 2017/04/15.
//  Copyright © 2017年 Hori,Masaki. All rights reserved.
//

import Cocoa
import Combine
import UniformTypeIdentifiers

private func loadImageTypes() -> [String] {
    
    guard let url = Bundle.main.url(forResource: "ImageType", withExtension: "plist"),
        let array = NSArray(contentsOf: url) else {
            
            return []
    }
    
    return array as? [String] ?? []
}

class ImageTypeItem: StatusItem {
    
    let menuItem = NSMenuItem()
    private let supportTypes = loadImageTypes()
    private var cancellables: Set<AnyCancellable> = []
    
    init() {
        
        menuItem.title = NSLocalizedString("Image Type", comment: "Image Type MenuItem")
        
        menuItem.submenu = NSMenu()
        
        supportTypes
            .compactMap(UTType.init)
            .map { (i: UTType) in
                
                let item = NSMenuItem()
                item.title = i.localizedDescription ?? "Never Use Default Value"
                item
                    .actionPublisher()
                    .sink { [weak self] _ in
                        guard let typeName = i.preferredFilenameExtension else { return }
                        self?.set(typeName)
                    }
                    .store(in: &cancellables)
                
                return item
            }
            .forEach {
                menuItem.submenu?.addItem($0)
            }
    }
    
    func update() {
        
        let current = Screenshot.shared.type
        menuItem.submenu?.items.forEach {
            
            if let type = $0.representedObject as? String,
                type == current {
                
                $0.state = .on
                
            } else {
                
                $0.state = .off
            }
        }
    }
    
    fileprivate func set(_ typeName: String) {
        
        DispatchQueue(label: "Launch defaults").async {
            
            Screenshot.shared.type = typeName
        }
    }
}

