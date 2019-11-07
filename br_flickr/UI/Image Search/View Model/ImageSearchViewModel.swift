//
//  ImageSearchViewModel.swift
//  br_flickr
//
//  Created by Abubakar Oladeji on 06/11/2019.
//  Copyright © 2019 Abubakar Oladeji. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class ImageSearchViewModel: ImageSearchViewModelProtocol {
    
    var currentPage: Int
    
    var total: Int?
    
    var pages: Int?
    
    var text: String?
    
    private let loadingRelay = BehaviorRelay<Bool>(value: false)
    var loading: Driver<Bool> { return loadingRelay.asDriver() }
    
    private let imageCache = BehaviorRelay<[PhotoInformation]>(value: [])
    var photos: Driver<[PhotoInformation]> = BehaviorRelay<[PhotoInformation]>(value: []).asDriver()
    
    private let errorRelay = BehaviorRelay<String>(value: "")
    var errorMessage: Driver<String> { return errorRelay.asDriver() }
    
    init(searchText: Driver<String?>, fetch: BehaviorRelay<Void>, disposeBag: DisposeBag) {
        self.currentPage = 1
        self.total = nil
        self.pages = nil
        self.text = nil
        
        photos = fetch
            .asObservable().flatMapLatest { [weak self] _ -> Observable<FlickrImageListResponse> in
                guard let self = self else { return Observable.empty() }
                if let total = self.total {
                    let calc = self.currentPage * self.perPage
                    if calc >= total {
                        let list = FlickrPhotosList(page: self.currentPage, pages: self.pages, perpage: self.perPage, total: self.total, photo: self.imageCache.value)
                        let mainResponse = FlickrImageListResponse(stat: "ok", photos: list)
                        return Observable.just(mainResponse)
                    }
                }
                return ImageSearchService(currentPage: self.currentPage, perPage: self.perPage, search: self.text).execute()
            }
            .map { self.processFetchedResults(response: $0) }
            .asDriver { (error) -> Driver<[PhotoInformation]> in
                self.errorRelay.accept("Error occured. Please, try again later")
                return Driver.just(self.imageCache.value)
            }
        
        searchText
            .throttle(.seconds(1))
            .drive(onNext: { (value) in
            self.text = value
            self.currentPage = 1
            self.total = nil
            self.pages = nil
            self.loadingRelay.accept(true)
            
            fetch.accept(())
        }).disposed(by: disposeBag)
    }
    
    private func processFetchedResults(response: FlickrImageListResponse?) -> [PhotoInformation] {
        
        if let total = self.total {
            let calc = self.currentPage * self.perPage
            if calc >= total { return self.imageCache.value }
        } else { self.imageCache.accept([])  }
        
        guard let response = response, let imageList = response.photos, let images = imageList.photo else {
            self.errorRelay.accept("Error occured. Please, try again later")
            return []
        }
        
        self.pages = imageList.pages
        self.total = imageList.total?.value
        self.currentPage += 1
        
        let currentImages = imageCache.value + images
        imageCache.accept(currentImages)
        self.errorRelay.accept("")
        return currentImages
    }
    
}
