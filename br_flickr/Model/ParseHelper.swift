//
//  ParseHelper.swift
//  br_flickr
//
//  Created by Abubakar Oladeji on 05/11/2019.
//  Copyright © 2019 Abubakar Oladeji. All rights reserved.
//

import Foundation

class ParseHelper<T: Codable> {
    
    private let data: Data
    
    init(data: Data) {
        self.data = data
    }
    
    func decodeObject() -> T? {
        let decoder = JSONDecoder()
        
        return try? decoder.decode(T.self, from: data)
    }
}
