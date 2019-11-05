//
//  RequestManagerMock.swift
//  br_flickrTests
//
//  Created by Abubakar Oladeji on 05/11/2019.
//  Copyright © 2019 Abubakar Oladeji. All rights reserved.
//

import Foundation

@testable import br_flickr

class RequestManagerMock: RequestManager {
    
    private let data: Data?
    
    init(data: Data? = nil) {
        self.data = data
    }
    
    override func handleGETRequest(urlString: String, session: URLSession = URLSession(configuration: .default), completion: @escaping RequestCompletion) -> URLSessionTask? {
        
        guard let _ = URL(string: urlString) else {
            completion(.failure(.network(string: "Wrong url format")))
            return nil
        }
        
        guard let data = data else {
            completion(.failure(.network(string: "Please try again later.")))
            return nil
        }
        
        completion(.success(data))
        return nil
    }
}
