//
//  LimitedArray.swift
//  GoInto
//
//  Created by Hori,Masaki on 2017/04/18.
//  Copyright © 2017年 Hori,Masaki. All rights reserved.
//

import Foundation

class LimitedArray<Element: Equatable>: Collection {
    
    private(set) var array: [Element] = []
    private let size: Int
    
    init(_ size: Int) {
        self.size = size
    }
    func append(_ newObject: Element) {
        if let index = array.index(of: newObject) {
            array.remove(at: index)
        }
        array.insert(newObject, at: 0)
        if array.count > size {
            array.remove(at: size)
        }
    }
    
    // Collection
    var startIndex: Int {
        return array.startIndex
    }
    var endIndex: Int {
        return array.endIndex
    }
    func index(after i: Int) -> Int {
        return array.index(after: i)
    }
    subscript(position: Int) -> Element {
        return array[position]
    }
}
extension LimitedArray: CustomDebugStringConvertible {
    var description: String { return array.description }
    var debugDescription: String { return array.debugDescription }
}
