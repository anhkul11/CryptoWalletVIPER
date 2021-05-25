//
//  CryptoListViewController.swift
//  CryptoWalletVIPER
//
//  Created by Le Quoc Anh on 5/25/21.
//

import UIKit

protocol CryptoListViewable: Viewable {
    func reloadTableView(with viewModels: [CryptoInfoViewModel])
}

final class CryptoListViewController: UIViewController, CryptoListViewable {
    
    var presenter: CryptoListPresentable!
    
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var favoritesButton: UIButton!
    @IBOutlet private weak var tableView: UITableView!
    
    private var viewModels: [CryptoInfoViewModel] = []
    
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
    }
    
    private func configureNavigationBar() {
        title = "CryptoWallet"
    }
}

// MARK: - CryptoListViewable
extension CryptoListViewController {
    func reloadTableView(with viewModels: [CryptoInfoViewModel]) {
        self.viewModels = viewModels
        tableView.reloadData()
    }
    
    func showError(with error: ServiceError) {
        
    }
}

// MARK: - UISearchBarDelegate
extension CryptoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

extension CryptoListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CryptoInfoTableViewCell.self), for: indexPath) as? CryptoInfoTableViewCell else {
            return UITableViewCell()
        }
        cell.configureView(with: viewModels[indexPath.row])
        return cell
    }
}
