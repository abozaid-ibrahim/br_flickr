//
//  ImageSearchCellTableViewCell.swift
//  br_flickr
//
//  Created by Abubakar Oladeji on 06/11/2019.
//  Copyright © 2019 Abubakar Oladeji. All rights reserved.
//

import UIKit
import RxSwift

class ImageSearchCell: UITableViewCell {

    @IBOutlet weak var contentImageView : UIImageView!
    @IBOutlet weak var contentTitle : UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var disposeBag: DisposeBag!
    
    var imageInformation: PhotoInformation? {
        didSet {
            guard let imageInformation = imageInformation else { return }
            contentTitle.text = imageInformation.title
            
            guard let imageUrl = imageInformation.url_o else { return }
            
            contentImageView
                .fetchImage(imageUrl)
                .subscribeOn(SerialDispatchQueueScheduler(qos: .background))
                .observeOn(MainScheduler.instance)
                .subscribe(onNext: { [weak self] (image) in
                    self?.contentImageView.image = image
                    self?.activityIndicator.stopAnimating()
                }).disposed(by: disposeBag)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentImageView.contentMode = .scaleAspectFit
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
