//
//  BaseSearchModel.swift
//  br_flickr
//
//  Created by Abubakar Oladeji on 05/11/2019.
//  Copyright © 2019 Abubakar Oladeji. All rights reserved.
//

import Foundation

//MARK: - Flickr List response
struct FlickrImageListResponse: Codable {
    
    let at: String?
    let photos: FlickrPhotosList?
    
    enum Codingkeys: String, CodingKey {
        case at = "at"
        case photo = "photos"
    }
}

struct FlickrPhotosList: Codable {
    
    let page: Int?
    let pages: Int?
    let perpage: Int?
    let total: UncertainValue<Int>?
    let photo: [PhotoInformation<String>]?
    
    enum Codingkeys: String, CodingKey {
        case page = "page"
        case pages = "pages"
        case perpage = "perpage"
        case total = "total"
    }
}

struct PhotoInformation<T: Codable>: Codable {
    
    let id: String?
    let secret: String?
    let server: String?
    let title: String?
    let owner: T?
    let urls: InfoUrls?
    
    struct InfoUrls: Codable {
        
        let url: [UrlObject]?
        
        enum Codingkeys: String, CodingKey {
            case url = "url"
        }
    }
    
    struct UrlObject: Codable {
        
        let type: String
        let content: String
        
        enum Codingkeys: String, CodingKey {
            case type = "type"
            case content = "_content"
        }
    }
    
    enum Codingkeys: String, CodingKey {
        case id = "id"
        case secret = "secret"
        case server = "server"
        case title = "title"
        case owner = "owner"
    }
}

//MARK: - Owner object
struct OwnerObject: Codable {
    
    let nsid: String?
    let username: String?
    let realname: String?
    
    enum Codingkeys: String, CodingKey {
        case nsid = "nsid"
        case username = "username"
        case realname = "realname"
    }
}

//MARK: - Image informationResponse
struct ImageInfoResponse: Codable {
    
    let at: String?
    let photo: PhotoInformation<OwnerObject>?
    
    enum Codingkeys: String, CodingKey {
        case at = "at"
        case photo = "photo"
    }
}

public struct UncertainValue<T: Codable>: Codable {
    
    var value: T?
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let intValue = try? container.decode(Int.self)
        let stringValue = try? container.decode(String.self)
        
        if let intValue = intValue {
            value = intValue as? T
        }
        
        if let stringValue = stringValue {
            let newValue = Int(stringValue)
            value = newValue as? T
        }
        
        if value == nil {
            throw DecodingError.typeMismatch(type(of: self), DecodingError.Context(codingPath: [], debugDescription: "The value is not of type \(T.self)"))
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(value)
    }
}
