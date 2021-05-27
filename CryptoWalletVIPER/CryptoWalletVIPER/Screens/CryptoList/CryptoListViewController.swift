//
//  CryptoListViewController.swift
//  CryptoWalletVIPER
//
//  Created by Le Quoc Anh on 5/25/21.
//

import UIKit

protocol CryptoListViewable: Viewable {
    var presenter: CryptoListPresentable! { get set }
    var viewModels: BehaviorRelay<[CryptoInfoViewModel]> { get }
    func endRefreshing()
}

final class CryptoListViewController: UIViewController, CryptoListViewable {
    
    var presenter: CryptoListPresentable!
    
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var allButton: UIButton!
    @IBOutlet private weak var favoritesButton: UIButton!
    @IBOutlet private weak var tableView: UITableView!
    
    let viewModels = BehaviorRelay<[CryptoInfoViewModel]>(value: [])
    private lazy var refreshControl = UIRefreshControl()
    private let disposeBag = DisposeBag()
    private lazy var didTapFavorite: ((String) -> ())? = { [weak presenter] base in
        presenter?.changFavoriteRelay.accept(base)
    }
    
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
        view.backgroundColor = UIColor(named: ColorName.backgroundColor)
        
        navigationController?.navigationBar.prefersLargeTitles = true

        searchBar.autocapitalizationType = .allCharacters
        searchBar.placeholder = "Search Crypto"
        searchBar.delegate = self
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: String(describing: CryptoInfoTableViewCell.self), bundle: nil),
                           forCellReuseIdentifier: String(describing: CryptoInfoTableViewCell.self))
        tableView.refreshControl = refreshControl
        tableView.backgroundColor = UIColor(named: ColorName.backgroundColor)
        
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
        
        favoritesButton.setTitleColor(.lightGray, for: .normal)
        allButton.setTitleColor(.link, for: .normal)
        
        let allButtonTap = allButton.rx.tap.map { false }
        let favoriteButtonTap = favoritesButton.rx.tap.map { true }
        
        Observable.merge(allButtonTap, favoriteButtonTap)
            .do(onNext: { [weak self] isFavorites in
                self?.favoritesButton.setTitleColor(isFavorites ? .link : .lightGray, for: .normal)
                self?.allButton.setTitleColor(isFavorites ? .lightGray : .link, for: .normal)
            })
            .bind(to: presenter.filterFavoritesRelay)
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
        DispatchQueue.main.async { [weak refreshControl] in
            refreshControl?.endRefreshing()
        }
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
        cell.configureView(with: viewModels.value[indexPath.row], favoriteAction: didTapFavorite)
        return cell
    }
}
