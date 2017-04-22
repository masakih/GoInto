//
//  LimitedArrayTest.swift
//  GoInto
//
//  Created by Hori,Masaki on 2017/04/19.
//  Copyright © 2017年 Hori,Masaki. All rights reserved.
//

import XCTest

@testable import GoInto

class LimitedArrayTest: XCTestCase {

    func testExample() {
        let limited = LimitedArray<Int>(3)
        XCTAssertEqual(limited.array, [])
        
        limited.append(1)
        XCTAssertEqual(limited.array, [1])
        limited.append(2)
        XCTAssertEqual(limited.array, [2, 1])
        limited.append(3)
        XCTAssertEqual(limited.array, [3, 2, 1])
        
        // push out
        limited.append(4)
        XCTAssertEqual(limited.array, [4, 3, 2])
        
        // replace
        limited.append(3)
        XCTAssertEqual(limited.array, [3, 4, 2])
    }

}
