//
//  RequestFactory.swift
//  br_flickr
//
//  Created by Abubakar Oladeji on 05/11/2019.
//  Copyright © 2019 Abubakar Oladeji. All rights reserved.
//

import Foundation

struct RequestFactory {
    
    enum Method: String {
        case GET
        case POST
        case PUT
        case DELETE
        case PATCH
    }
    
    static func request(method: Method, url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        return request
    }
}
