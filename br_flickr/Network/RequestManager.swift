//
//  RequestManager.swift
//  br_flickr
//
//  Created by Abubakar Oladeji on 05/11/2019.
//  Copyright © 2019 Abubakar Oladeji. All rights reserved.
//

import Foundation

public enum BRError: Error {
    
    case network(string: String)
    case custom(string: String)
    
    var localizedDescription: String {
        switch self {
            case .network(let value):
                return value
            case .custom(let value):
                return value
        }
    }
}

open class RequestManager: NSObject {
    
    public typealias RequestCompletion = (Result<Data, BRError>) -> ()
    
    func handleGETRequest(urlString: String, session: URLSession = URLSession(configuration: .default), completion: @escaping RequestCompletion) -> URLSessionTask? {
        guard let url = URL(string: urlString) else {
            completion(.failure(.network(string: "Wrong url format")))
            return nil
        }
        
        var request = RequestFactory.request(method: .GET, url: url)
        
        let cache =  URLCache.shared
        
        if let data = cache.cachedResponse(for: request)?.data {
            completion(.success(data))
            return nil
        }
        
        if let reachability = try? Reachability(), reachability.connection == .unavailable {
            request.cachePolicy = .returnCacheDataDontLoad
        }
        
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(.network(string: "\(error.localizedDescription), please try again later.")))
                return
            }
            
            if let data = data, let response = response, ((response as? HTTPURLResponse)?.statusCode ?? 500) < 300 {
                let cachedData = CachedURLResponse(response: response, data: data)
                cache.storeCachedResponse(cachedData, for: request)
                completion(.success(data))
            }
        }
        task.resume()
        return task
    }
}
