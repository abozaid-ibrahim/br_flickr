//
//  br_flickrTests.swift
//  br_flickrTests
//
//  Created by Abubakar Oladeji on 05/11/2019.
//  Copyright © 2019 Abubakar Oladeji. All rights reserved.
//

import XCTest
@testable import br_flickr

class br_flickrTests: XCTestCase {

    func testEnvironmentConfig() {
        
        // Test to ensure API Key is added to config
        XCTAssertNoThrow(BREnvironment.flickrAPIKey)
        
        // Test to ensure Flickr URL is added to config
        XCTAssertNoThrow(BREnvironment.flickrURLString)
        
        // Test to ensure URL is valid
        let urlCheck = BREnvironment.flickrURLString == BREnvironment.flickrURL.absoluteString
        XCTAssertTrue(urlCheck)
    }

}
