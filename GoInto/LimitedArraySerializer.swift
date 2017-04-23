//
//  LimitedArraySerializer.swift
//  GoInto
//
//  Created by Hori,Masaki on 2017/04/21.
//  Copyright © 2017年 Hori,Masaki. All rights reserved.
//

import Foundation

protocol SerializerProvider {
    var serializer: Serializer { get }
}
protocol Serializer {
    var original: SerializerProvider? { get }
}

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
        let array = aDecoder.decodeObject(forKey: LimitedArrayWrapperCodingKey.array)
        switch array {
        case let elements as [Element]:
            self.array = elements
        case let serialized as [Serializer]:
            self.array = serialized.flatMap { $0.original as? Element }
        default:
            return nil
        }
        size = aDecoder.decodeInteger(forKey: LimitedArrayWrapperCodingKey.size)
    }
    func encode(with aCoder: NSCoder) {
        if let serializable = array as? [SerializerProvider] {
            let storeArray = serializable.map { $0.serializer }
            aCoder.encode(storeArray, forKey: LimitedArrayWrapperCodingKey.array)
        } else {
            aCoder.encode(array, forKey: LimitedArrayWrapperCodingKey.array)
        }
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
        var limited = LimitedArray<Element>(wrapper.size)
        wrapper.array.reversed().forEach { limited.append($0) }
        return limited
    }
}
