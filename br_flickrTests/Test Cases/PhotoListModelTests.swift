//
//  PhotoListModelTests.swift
//  br_flickrTests
//
//  Created by Abubakar Oladeji on 05/11/2019.
//  Copyright © 2019 Abubakar Oladeji. All rights reserved.
//

import XCTest
@testable import br_flickr

class PhotoListModelTests: XCTestCase {
    
    func testSearchModelTotalSync() {
        
        // Test Search response
        let searchData = loadStubFromBundle(withName: "flickr_search_response", extension: "json")
        
        let searchModel = ParseHelper<FlickrImageListResponse>(data: searchData).decodeObject()
        
        XCTAssertNotNil(searchModel, "Search model cannot be nil")
        
        XCTAssertNotNil(searchModel?.photos, "Photos cannot be nil")
        
        XCTAssertNotNil(searchModel?.photos?.total?.value, "Total cannot be nil")
        
        XCTAssertEqual(searchModel!.photos!.total!.value!, 3531, "Invalid value, expected 3531 found \(searchModel!.photos!.total!.value!)")
        
        XCTAssertNotNil(searchModel!.photos!.photo, "Photo array shouldn't be nill")
        
        XCTAssertTrue(searchModel!.photos!.photo!.count > 0, "Photo array shouldn't be empty")
    }
    
    func testRecentModelTotalSync() {
        
        // Test Search response
        let recentData = loadStubFromBundle(withName: "flickr_recent_response", extension: "json")
        
        let recentModel = ParseHelper<FlickrImageListResponse>(data: recentData).decodeObject()
        
        XCTAssertNotNil(recentModel, "Recent model cannot be nil")
        
        XCTAssertNotNil(recentModel?.photos, "Photos cannot be nil")
        
        XCTAssertNotNil(recentModel?.photos?.total?.value, "Total cannot be nil")
        
        XCTAssertEqual(recentModel!.photos!.total!.value!, 1000, "Invalid value, expected 3531 found \(recentModel!.photos!.total!.value!)")
        
        XCTAssertNotNil(recentModel!.photos!.photo, "Photo array shouldn't be nill")
        
        XCTAssertTrue(recentModel!.photos!.photo!.count > 0, "Photo array shouldn't be empty")
    }
}
