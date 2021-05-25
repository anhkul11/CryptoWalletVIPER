//
//  CryptoListViewController.swift
//  CryptoWalletVIPER
//
//  Created by Le Quoc Anh on 5/25/21.
//

import UIKit

protocol CryptoListViewable: Viewable {
    var viewModels: BehaviorRelay<[CryptoInfoViewModel]> { get }
    func endRefreshing()
}

final class CryptoListViewController: UIViewController, CryptoListViewable {
    
    var presenter: CryptoListPresentable!
    
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var favoritesButton: UIButton!
    @IBOutlet private weak var tableView: UITableView!
    
    let viewModels = BehaviorRelay<[CryptoInfoViewModel]>(value: [])
    private lazy var refreshControl = UIRefreshControl()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        defer {
            presenter.viewDidLoadRelay.accept(())
        }
        configureView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigationBar()
    }
}

// MARK: - Private functions
extension CryptoListViewController {
    private func configureView() {
        navigationController?.navigationBar.prefersLargeTitles = true

        searchBar.autocapitalizationType = .allCharacters
        searchBar.placeholder = "Search Crypto"
        searchBar.delegate = self
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: String(describing: CryptoInfoTableViewCell.self), bundle: nil),
                           forCellReuseIdentifier: String(describing: CryptoInfoTableViewCell.self))
        tableView.refreshControl = refreshControl
        
        refreshControl.rx.controlEvent(.valueChanged)
            .bind(to: presenter.refreshDataRelay)
            .disposed(by: disposeBag)
        
        viewModels.asDriver()
            .drive(onNext: { [weak self] viewModels in
                self?.tableView.reloadData()
            }).disposed(by: disposeBag)
        
        searchBar.rx.text
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
            .compactMap { $0 }
            .bind(to: presenter.filterTextRelay)
            .disposed(by: disposeBag)
    }
    
    private func configureNavigationBar() {
        title = "CryptoWallet"
    }
}

// MARK: - CryptoListViewable
extension CryptoListViewController {
    func showError(with error: ServiceError) {
        
    }
    
    func endRefreshing() {
        refreshControl.endRefreshing()
    }
}

// MARK: - UISearchBarDelegate
extension CryptoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        presenter.filterTextRelay.accept(searchBar.text ?? "")
    }
}

extension CryptoListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.value.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CryptoInfoTableViewCell.self), for: indexPath) as? CryptoInfoTableViewCell else {
            return UITableViewCell()
        }
        cell.configureView(with: viewModels.value[indexPath.row])
        return cell
    }
}
