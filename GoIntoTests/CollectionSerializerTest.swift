//
//  CollectionSerializerTest.swift
//  GoInto
//
//  Created by Hori,Masaki on 2017/04/21.
//  Copyright © 2017年 Hori,Masaki. All rights reserved.
//

import XCTest

@testable import GoInto


class CollectionSerializerTest: XCTestCase {

    func testExample() {
        let limited = LimitedArray<Int>(3)
        limited.append(1)
        limited.append(2)
        limited.append(3)
        
        let data = LimitedArraySerializer.seirialize(limited)
        XCTAssertNotNil(data)
        let object: LimitedArray<Int> = LimitedArraySerializer.deserialize(data) ?? LimitedArray<Int>(3)
        
        XCTAssertEqual(object.array, limited.array)
        XCTAssertEqual(object.size, limited.size)
    }
    
    func testURL() {
        let limited = LimitedArray<URL>(3)
        limited.append(URL(fileURLWithPath: "/System/"))
        limited.append(URL(fileURLWithPath: "/Users/"))
        limited.append(URL(fileURLWithPath: "/var/"))
        
        let data = LimitedArraySerializer.seirialize(limited)
        XCTAssertNotNil(data)
        let object: LimitedArray<URL> = LimitedArraySerializer.deserialize(data) ?? LimitedArray<URL>(3)
        
        XCTAssertEqual(object.array, limited.array)
        XCTAssertEqual(object.size, limited.size)
    }
    
    func testSize() {
        let limited = LimitedArray<URL>(5)
        limited.append(URL(fileURLWithPath: "/System/"))
        limited.append(URL(fileURLWithPath: "/Users/"))
        limited.append(URL(fileURLWithPath: "/var/"))
        
        let data = LimitedArraySerializer.seirialize(limited)
        XCTAssertNotNil(data)
        let object: LimitedArray<URL> = LimitedArraySerializer.deserialize(data) ?? LimitedArray<URL>(5)
        
        XCTAssertEqual(object.array, limited.array)
        XCTAssertEqual(object.size, limited.size)
    }

}
