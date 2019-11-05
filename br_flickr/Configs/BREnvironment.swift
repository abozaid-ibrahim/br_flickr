//
//  BREnvironment.swift
//  br_flickr
//
//  Created by Abubakar Oladeji on 05/11/2019.
//  Copyright © 2019 Abubakar Oladeji. All rights reserved.
//

import Foundation

enum BREnvironment {
    
    //MARK: - Config keys
    enum Keys {
        enum Plist {
            static let FLICKR_ROOT_URL = "FLICKR_ROOT_URL"
            static let FLICKR_API_KEY = "FLICKR_API_KEY"
        }
    }
    
    private static let infoDictionary: [String: Any] = {
        guard let dict = Bundle.main.infoDictionary else {
            fatalError("Configuration file not found")
        }
        return dict
    }()
    
    //MARK: - FLICKR
    // Root URL
    static let flickrURL: URL = {
        
        guard let url = URL(string: flickrURLString) else {
            fatalError("\(Keys.Plist.FLICKR_ROOT_URL) is invalid")
        }
        return url
    }()
    
    // Root URL String
    static let flickrURLString: String = {
        guard let urlString = BREnvironment.infoDictionary[Keys.Plist.FLICKR_ROOT_URL] as? String else {
            fatalError("\(Keys.Plist.FLICKR_ROOT_URL) not set in plist for this environment")
        }
        return urlString
    }()
    
    // API Key
    static let flickrAPIKey: String = {
        guard let apiKey = BREnvironment.infoDictionary[Keys.Plist.FLICKR_API_KEY] as? String else {
            fatalError("\(Keys.Plist.FLICKR_API_KEY) not set in plist for this environment")
        }
        
        return apiKey
    }()
}
