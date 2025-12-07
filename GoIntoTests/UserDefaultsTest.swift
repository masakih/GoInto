//
//  UserDefaultsTest.swift
//  GoInto
//
//  Created by Hori,Masaki on 2017/04/23.
//  Copyright © 2017年 Hori,Masaki. All rights reserved.
//

import Foundation
import Testing

@testable import GoInto

class UserDefaultsTest {
    
    var originalURLs: [URL]? = []
    
    init() {
        originalURLs = UserDefaults.standard.recentURLs
    }
    
    deinit {
        
        UserDefaults.standard.recentURLs = originalURLs
    }
    
    @Test
    func testRecentFolders() throws {
        
        let urls = [URL(fileURLWithPath: "/System/"),
                    URL(fileURLWithPath: "/Users/"),
                    URL(fileURLWithPath: "/var/")]
        
        UserDefaults.standard.recentURLs = urls
        
        let stored = try #require(UserDefaults.standard.recentURLs)
        
        #expect(urls == stored)
    }
}
