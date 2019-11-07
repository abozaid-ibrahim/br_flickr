//
//  ImageSearchService.swift
//  br_flickr
//
//  Created by Abubakar Oladeji on 06/11/2019.
//  Copyright © 2019 Abubakar Oladeji. All rights reserved.
//

import Foundation
import RxSwift

class ImageSearchService: RequestUseCase {
    
    private let currentPage: Int
    private let perPage: Int
    private let search: String?
    
    private let BASE_URL = BREnvironment.flickrURLString
    private let APIKEY = BREnvironment.flickrAPIKey
    
    init(currentPage: Int = 1, perPage: Int = 25, search: String? = nil) {
        self.currentPage = currentPage
        self.perPage = perPage
        self.search = search
    }
    
    func execute() -> Observable<FlickrImageListResponse> {
        if let search = search {
            return searchForImages(search)
        }
        
        return getRecentImages()
    }
    
    private func getRecentImages() -> Observable<FlickrImageListResponse> {
        
        let urlConstruct = "\(BASE_URL)?method=flickr.photos.getRecent&api_key=\(APIKEY)&format=json&per_page=\(perPage)&nojsoncallback=1&page=\(currentPage)&extras=url_o,owner_name"
        
        return Observable.create { observer in
            
            let task = RequestManager().handleGETRequest(urlString: urlConstruct) { (result) in
                do {
                    let response = try result.get()
                    let helper = ParseHelper<FlickrImageListResponse>(data: response)
                    guard let imageResponse = helper.decodeObject() else {
                        observer.onError(BRError.custom(string: "Error decoding response. Please, try again later."))
                        return
                    }
                    
                    observer.onNext(imageResponse)
                } catch {
                    observer.onError(BRError.custom(string: "Error decoding response. Please, try again later."))
                }
            }
            return Disposables.create { task?.cancel() }
        }
    }
    
    private func searchForImages(_ search: String) -> Observable<FlickrImageListResponse> {
        let urlConstruct = "\(BASE_URL)?method=flickr.photos.search&api_key=\(APIKEY)&format=json&per_page=\(perPage)&nojsoncallback=1&page=\(currentPage)&text=\(search)&extras=url_o,owner_name"
        
        return Observable.create { observer in
            
            let task = RequestManager().handleGETRequest(urlString: urlConstruct) { (result) in
                do {
                    let response = try result.get()
                    let helper = ParseHelper<FlickrImageListResponse>(data: response)
                    guard let imageResponse = helper.decodeObject() else {
                        observer.onError(BRError.custom(string: "Error decoding response. Please, try again later."))
                        return
                    }
                    
                    observer.onNext(imageResponse)
                } catch {
                    observer.onError(BRError.custom(string: "Error decoding response. Please, try again later."))
                }
            }
            return Disposables.create { task?.cancel() }
        }
    }
}
