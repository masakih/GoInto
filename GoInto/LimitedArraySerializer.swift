//
//  LimitedArraySerializer.swift
//  GoInto
//
//  Created by Hori,Masaki on 2017/04/21.
//  Copyright © 2017年 Hori,Masaki. All rights reserved.
//

import Foundation

private struct LimitedArrayWrapperCodingKey {
    static let array = "LimitedArrayWrapperCodingKey.Array"
    static let size = "LimitedArrayWrapperCodingKey.Size"
}

private class LimitedArrayWrapper<Element: Equatable>: NSObject, NSCoding {
    let array: [Element]
    let size: Int
    
    init(_ limited: LimitedArray<Element>) {
        array = limited.array
        size = limited.size
    }
    required init?(coder aDecoder: NSCoder) {
        guard let array = aDecoder.decodeObject(forKey: LimitedArrayWrapperCodingKey.array) as? [Element]
            else { return nil }
        self.array = array
        size = aDecoder.decodeInteger(forKey: LimitedArrayWrapperCodingKey.size)
    }
    func encode(with aCoder: NSCoder) {
        aCoder.encode(array, forKey: LimitedArrayWrapperCodingKey.array)
        aCoder.encode(size, forKey: LimitedArrayWrapperCodingKey.size)
    }
}

class LimitedArraySerializer {
    
    class func seirialize<Element>(_ object: LimitedArray<Element>) -> Data {
        let wrapper = LimitedArrayWrapper(object)
        return NSKeyedArchiver.archivedData(withRootObject: wrapper)
    }
    
    class func deserialize<Element>(_ data: Data) -> LimitedArray<Element>? {
        guard let wrapper = NSKeyedUnarchiver.unarchiveObject(with: data) as? LimitedArrayWrapper<Element>
            else { return nil }
        let limited = LimitedArray<Element>(wrapper.size)
        wrapper.array.reversed().forEach(limited.append)
        return limited
    }
}
