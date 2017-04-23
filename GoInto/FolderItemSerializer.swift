//
//  FolderItemSerializer.swift
//  GoInto
//
//  Created by Hori,Masaki on 2017/04/23.
//  Copyright © 2017年 Hori,Masaki. All rights reserved.
//

import Foundation

final class FolderItemSerializer: NSObject, NSCoding {
    fileprivate let url: URL
    var folderItem: FolderItem { return FolderItem(url) }
    
    init(_ url: URL) {
        self.url = url
    }
    
    private struct CodingKey {
        static let url = "FolderItemWrapper.url"
    }
    
    init?(coder aDecoder: NSCoder) {
        guard let url = aDecoder.decodeObject(forKey: CodingKey.url) as? URL
            else { return nil }
        self.url = url
    }
    func encode(with aCoder: NSCoder) {
        aCoder.encode(url, forKey: CodingKey.url)
    }
}
extension FolderItemSerializer: Serializer {
    var original: SerializerProvider? { return FolderItem(url) }
}

extension FolderItem: SerializerProvider {
    var serializer: Serializer { return FolderItemSerializer(url) }
}
