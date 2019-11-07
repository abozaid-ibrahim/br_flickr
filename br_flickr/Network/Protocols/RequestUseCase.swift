//
//  RequestUseCase.swift
//  br_flickr
//
//  Created by Abubakar Oladeji on 06/11/2019.
//  Copyright © 2019 Abubakar Oladeji. All rights reserved.
//

import Foundation
import RxSwift

protocol RequestUseCase {
    associatedtype T
    
    func execute() -> T
    func observe() -> Observable<T>
}

extension RequestUseCase {
    
    func execute() -> T {
        fatalError("Unimplemented Use Case method `execute()`")
    }
    
    func observe() -> Observable<T> {
        return Observable.just(execute())
    }
}
