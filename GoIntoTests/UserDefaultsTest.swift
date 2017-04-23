//
//  UserDefaultsTest.swift
//  GoInto
//
//  Created by Hori,Masaki on 2017/04/23.
//  Copyright © 2017年 Hori,Masaki. All rights reserved.
//

import XCTest

@testable import GoInto

class UserDefaultsTest: XCTestCase {
    
    func testRecentFolders() {
        var limited = LimitedArray<FolderItem>(3)
        limited.append(FolderItem(URL(fileURLWithPath: "/System/")))
        limited.append(FolderItem(URL(fileURLWithPath: "/Users/")))
        limited.append(FolderItem(URL(fileURLWithPath: "/var/")))
        
        UserDefaults.standard.recentFolders = limited
        
        let storedData = UserDefaults.standard.recentFolders
        XCTAssertNotNil(storedData)
        guard let stored = storedData else { return }
        
        XCTAssertEqual(limited.array, stored.array)
        XCTAssertEqual(limited.size, stored.size)
    }
}
