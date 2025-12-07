//
//  LimitedArrayTest.swift
//  GoInto
//
//  Created by Hori,Masaki on 2017/04/19.
//  Copyright © 2017年 Hori,Masaki. All rights reserved.
//

import Testing

@testable import GoInto

struct LimitedArrayTest {

    @Test func testExample() {
        
        var limited = LimitedArray<Int>(3)
        #expect(limited.array == [])
        
        limited.append(1)
        #expect(limited.array == [1])
        limited.append(2)
        #expect(limited.array == [2, 1])
        limited.append(3)
        #expect(limited.array == [3, 2, 1])
        
        // push out
        limited.append(4)
        #expect(limited.array == [4, 3, 2])
        
        // replace
        limited.append(3)
        #expect(limited.array == [3, 4, 2])
    }

}
