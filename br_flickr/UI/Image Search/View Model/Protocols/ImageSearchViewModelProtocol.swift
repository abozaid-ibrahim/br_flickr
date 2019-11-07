//
//  ImageSearchViewModelProtocol.swift
//  br_flickr
//
//  Created by Abubakar Oladeji on 06/11/2019.
//  Copyright © 2019 Abubakar Oladeji. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol ImageSearchViewModelProtocol {
    
    var currentPage: Int { get }
    var perPage: Int { get }
    var total: Int? { get }
    var pages: Int? { get }
    var text: String? { get }
    
    // Outputs
    var photos: Driver<[PhotoInformation]> { get }
    var errorMessage: Driver<String> { get }
    
    var loading: Driver<Bool> { get }
}

extension ImageSearchViewModelProtocol {
    
    var perPage: Int {
        return 25
    }
    
    var currentPage: Int {
        return 1
    }
}
