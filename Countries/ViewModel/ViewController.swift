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
import Reachability

class ViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    private let cellIdentifier = "cellIdentifier"
    private let apiClient = APIClient()
    private let disposeBag = DisposeBag()
    private var reachability: Reachability?
    private var isOnline:Bool = false


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
        onlineOfflineConfigureReactiveBinding()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        reachabilityConfig()
    }
    
    private func reachabilityConfig(){
        let reachability: Reachability?
        reachability = Reachability()
        self.reachability = reachability
        
        reachability?.whenReachable = {[weak self] reachability in
            print("reachable")
            self?.isOnline = true
        }
        reachability?.whenUnreachable = { [weak self] _ in
            print("Not reachable")
            self?.isOnline = false
        }
        
        startNotifier()
    }
    
    func startNotifier() {
        do {
            try reachability?.startNotifier()
        } catch {
            return
        }
    }
    
    func stopNotifier() {
        reachability?.stopNotifier()
        reachability = nil
    }
    
    deinit {
        stopNotifier()
    }
    
    private func configureProperties() {
        navigationItem.searchController = searchController
        navigationItem.title = "Countries finder"
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
}

extension ViewController{
    
    private func onlineOfflineConfigureReactiveBinding() {
        searchController.searchBar.rx.text.asObservable()
            .map { ($0 ?? "").lowercased() }
            .map { self.isOnline ? CountriesRequest(name: $0) : CountriesRequest(name: $0)}
            .flatMap { request -> Observable<[CountriesModel]> in
                return self.isOnline ? self.apiClient.send(apiRequest: request) : self.apiClient.getOfflineData(searchText: request.parameters)
            }
            .bind(to: tableView.rx.items(cellIdentifier: cellIdentifier, cellType: TableCellView.self)) { index, model, cell in
                cell.countriesModel = model
            }
            .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(CountriesModel.self)
            .map { DetailsViewController.init(countriesModel: $0) }
            .subscribe(onNext: { [weak self] detailsViewController in
                self?.navigationController?.pushViewController(detailsViewController, animated: true)
            })
            .disposed(by: disposeBag)
    }
}

