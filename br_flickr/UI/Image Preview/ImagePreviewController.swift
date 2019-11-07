//
//  ImagePreviewController.swift
//  br_flickr
//
//  Created by Abubakar Oladeji on 07/11/2019.
//  Copyright © 2019 Abubakar Oladeji. All rights reserved.
//

import UIKit
import RxSwift

class ImagePreviewController: UIViewController {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.medium)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let imagePreview: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .darkGray
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let disposeBag = DisposeBag()
    
    var imageInformation: PhotoInformation? {
        didSet {
            titleLabel.text = imageInformation?.title
            if let imageUrl = imageInformation?.url_o {
                imagePreview
                    .fetchImage(imageUrl)
                    .subscribeOn(SerialDispatchQueueScheduler(qos: .background))
                    .observeOn(MainScheduler.instance)
                    .subscribe(onNext: { [weak self] (image) in
                        self?.imagePreview.image = image
                    }).disposed(by: disposeBag)
            }
            
            if let name = imageInformation?.ownername {
                title = name
            } else { title = "Image Preview" }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        view.addSubview(titleLabel)
        view.addSubview(imagePreview)
        
        if #available(iOS 11.0, *) {
            titleLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16).isActive = true
        } else { titleLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16).isActive = true }
        titleLabel.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -32).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        imagePreview.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        imagePreview.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        imagePreview.bottomAnchor.constraint(equalTo: titleLabel.topAnchor, constant: -8).isActive = true
        if #available(iOS 11.0, *) {
            imagePreview.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        } else { imagePreview.topAnchor.constraint(equalTo: view.topAnchor).isActive = true }
    }
}
