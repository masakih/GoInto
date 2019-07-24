//
//  LimitedArray.swift
//  GoInto
//
//  Created by Hori,Masaki on 2017/04/18.
//  Copyright © 2017年 Hori,Masaki. All rights reserved.
//


struct LimitedArray<Element: Equatable>: Sequence {
    
    private(set) var array: [Element] = []
    let size: Int
    
    init(_ size: Int) {
        
        self.size = size
    }
    
    mutating func append(_ newObject: Element) {
        
        if let index = array.firstIndex(of: newObject) {
            
            array.remove(at: index)
        }
        array.insert(newObject, at: 0)
        if array.count > size {
            
            array.dropLast()
        }
    }
    
    // Sequence
    func makeIterator() -> IndexingIterator<Array<Element>> {
        
        return array.makeIterator()
    }
}
extension LimitedArray: CustomDebugStringConvertible {
    
    var description: String { return array.description }
    var debugDescription: String { return array.debugDescription }
}
