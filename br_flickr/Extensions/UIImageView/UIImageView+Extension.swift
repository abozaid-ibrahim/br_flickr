//
//  UIImageView+Extension.swift
//  br_flickr
//
//  Created by Abubakar Oladeji on 06/11/2019.
//  Copyright © 2019 Abubakar Oladeji. All rights reserved.
//

import UIKit
import RxSwift

extension UIImageView {
    
    func fetchImage(_ urlString: String) -> Observable<UIImage?> {
        
        return Observable.create { observer in
            
            let task = RequestManager().handleGETRequest(urlString: urlString) { (result) in
                if let response = try? result.get(), let image = UIImage(data: response) {
                    observer.onNext(image)
                } else { observer.onNext(nil) }
            }
            
            return Disposables.create { task?.cancel() }
        }
    }
}
