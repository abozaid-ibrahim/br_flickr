//
//  ViewController.swift
//  br_flickr
//
//  Created by Abubakar Oladeji on 05/11/2019.
//  Copyright © 2019 Abubakar Oladeji. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {

    @IBOutlet weak var mainTableView: UITableView!
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    private let fetchRelay = BehaviorRelay<Void>(value: ())
    
    private let searchRelay = BehaviorRelay<String?>(value: nil)
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search terms"
        
        if #available(iOS 13.0, *) {
            searchController.automaticallyShowsCancelButton = true
        } else {
            searchController.searchBar.showsCancelButton = true
        }
        
        if #available(iOS 11.0, *) {
            navigationItem.searchController = searchController
        } else { mainTableView.tableHeaderView = searchController.searchBar }
        definesPresentationContext = true
        
        mainTableView.tableFooterView = UIView()
        mainTableView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
        
        mainTableView.rx.itemSelected.subscribe(onNext: { [weak self] (indexPath) in
            guard let self = self, let cell = self.mainTableView.cellForRow(at: indexPath) as? ImageSearchCell else { return }
            let controller = ImagePreviewController()
            controller.imageInformation = cell.imageInformation
            self.navigationController?.pushViewController(controller, animated: true)
        }).disposed(by: disposeBag)
        
        let viewModel = ImageSearchViewModel(searchText: searchRelay.asDriver(), fetch: fetchRelay, disposeBag: disposeBag)
        
        viewModel.photos
            .drive(self.mainTableView.rx.items(cellIdentifier: "photo_list_item", cellType: ImageSearchCell.self)) { [weak self] (row, photo, cell) in
                guard let self = self else { return }
                cell.disposeBag = self.disposeBag
                cell.contentImageView.image = nil
                cell.imageInformation = photo
            }.disposed(by: disposeBag)
        
        self.fetchRelay.accept(())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let indexPath = mainTableView.indexPathForSelectedRow {
            mainTableView.deselectRow(at: indexPath, animated: true)
        }
    }
}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 220
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard scrollView == mainTableView, (scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height else { return }
        
        self.fetchRelay.accept(())
    }
}

extension ViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        let text: String? = (searchBar.text != nil && searchBar.text!.count > 0) ? searchBar.text : nil
        
        searchRelay.accept(text)
    }
}
