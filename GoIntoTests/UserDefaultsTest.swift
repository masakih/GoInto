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
    
    var originalURLs: [URL]? = []
    
    override func setUp() {
        
        super.setUp()
        originalURLs = UserDefaults.standard.recentURLs
    }
    
    override func tearDown() {
        
        UserDefaults.standard.recentURLs = originalURLs
        super.tearDown()
    }
    
    func testRecentFolders() {
        
        let urls = [URL(fileURLWithPath: "/System/"),
                    URL(fileURLWithPath: "/Users/"),
                    URL(fileURLWithPath: "/var/")]
        
        UserDefaults.standard.recentURLs = urls
        
        let storedData = UserDefaults.standard.recentURLs
        XCTAssertNotNil(storedData)
        guard let stored = storedData else { return }
        
        XCTAssertEqual(urls, stored)
    }
}
