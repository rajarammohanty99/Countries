//
//  ViewController.swift
//  Countries
//
//  Created by Rajaram Mohanty on 28/06/19.
//  Copyright © 2019 Rajaram Mohanty. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa


class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private let cellIdentifier = "cellIdentifier"
    private let apiClient = APIClient()
    private let disposeBag = DisposeBag()
    
    var tasks :Variable<[CountriesModel]> = Variable([])

    private let searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "Search for Countries"
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        return searchController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureProperties()
        configureReactiveBinding()
    }
    
    private func configureProperties() {
//        let nib = UINib(nibName: "TableCellView", bundle: nil)
//        tableView.register(nib, forCellReuseIdentifier: cellIdentifier)
        navigationItem.searchController = searchController
        navigationItem.title = "Countries finder"
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    
    private func configureReactiveBinding() {
        searchController.searchBar.rx.text.asObservable()
            .map { ($0 ?? "").lowercased() }
            .map { CountriesRequest(name: $0) }
            .flatMap { request -> Observable<[CountriesModel]> in
                return self.apiClient.send(apiRequest: request)
            }
            .bind(to: tableView.rx.items(cellIdentifier: cellIdentifier, cellType: TableCellView.self)) { index, model, cell in
                cell.countriesModel = model
            }
            .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(CountriesModel.self)
            .map { DetailsViewController.init(countriesModel: $0) }
            .subscribe(onNext: { [weak self] detailsViewController in
                guard let strongSelf = self else { return }
                self?.navigationController?.pushViewController(detailsViewController, animated: true)
                detailsViewController.task.subscribe(onNext :{ [weak self] task in
                    self?.tasks.value.append(task)
                }).disposed(by: strongSelf.disposeBag)
            })
            .disposed(by: disposeBag)
    }
}
