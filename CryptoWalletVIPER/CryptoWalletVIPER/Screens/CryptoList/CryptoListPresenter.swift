//
//  CryptoListPresenter.swift
//  CryptoWalletVIPER
//
//  Created by Le Quoc Anh on 5/25/21.
//

import Foundation

protocol CryptoListPresentable: Presentable {
    var viewDidLoadRelay: PublishRelay<Void> { get }
    var refreshDataRelay: PublishRelay<Void> { get }
    var filterTextRelay: BehaviorRelay<String> { get }
    var changFavoriteRelay: PublishRelay<String> { get }
    var filterFavoritesRelay: BehaviorRelay<Bool> { get }
}

final class CryptoListPresenter: CryptoListPresentable {
    
    private let view: CryptoListViewable!
    private let interactor: CryptoListInteractable
    private let router: CryptoListRoutable
    private let disposeBag = DisposeBag()
    
    private var cryptoList = [Crypto]()
    
    init(view: CryptoListViewable, interactor: CryptoListInteractable, router: CryptoListRoutable) {
        self.view = view
        self.interactor = interactor
        self.router = router
        view.presenter = self
        interactor.presenter = self
        
        configurePresenter()
    }
    
    let viewDidLoadRelay = PublishRelay<Void>()
    let refreshDataRelay = PublishRelay<Void>()
    let filterTextRelay = BehaviorRelay<String>(value: "")
    let changFavoriteRelay = PublishRelay<String>()
    let filterFavoritesRelay = BehaviorRelay<Bool>(value: false)
    
    private func configurePresenter() {
        Observable
            .merge(viewDidLoadRelay.asObservable(), refreshDataRelay.asObservable())
            .subscribe(onNext: { [weak interactor] in
                interactor?.getCryptoList()
            }).disposed(by: disposeBag)
        
        Observable.combineLatest(filterTextRelay, filterFavoritesRelay.distinctUntilChanged())
            .observe(on: SerialDispatchQueueScheduler(qos: .userInitiated))
            .compactMap { [weak self] (filter, isFavorite) -> [Crypto]? in
                var filterList = self?.cryptoList
                if isFavorite {
                    filterList = filterList?
                        .filter { $0.isFavorite == true }
                }
                if !filter.isEmpty {
                    filterList = filterList?.filter { ($0.base ?? "").uppercased().contains(filter) || ($0.name ?? "").uppercased().contains(filter) }
                }
                return filterList
            }.map { cryptos in
                cryptos.map { crypto in
                    let url = URL(string: crypto.icon ?? "")
                    return CryptoInfoViewModel(iconURL: url,
                                               name: crypto.name,
                                               base: crypto.base?.uppercased(),
                                               salePrice: crypto.sell,
                                               buyPrice: crypto.buy,
                                               isFavorite: crypto.isFavorite)
                }
            }.bind(to: view.viewModels)
            .disposed(by: disposeBag)
        
        changFavoriteRelay.subscribe(onNext: { [weak interactor] base in
            interactor?.updateFavorite(for: base)
        }).disposed(by: disposeBag)
    }
}

extension CryptoListPresenter: CryptoListInteractableListener {
    func onSearchCryptoListSuccess(_ cryptoList: [Crypto]) {
        let viewModels: [CryptoInfoViewModel] = cryptoList.map { crypto in
            let url = URL(string: crypto.icon ?? "")
            return CryptoInfoViewModel(iconURL: url,
                                       name: crypto.name,
                                       base: crypto.base?.uppercased(),
                                       salePrice: crypto.sell,
                                       buyPrice: crypto.buy,
                                       isFavorite: crypto.isFavorite)
        }
        self.cryptoList = cryptoList
        view.endRefreshing()
        view.viewModels.accept(viewModels)
    }
    
    func onSearchError(_ error: Error) {
        view.endRefreshing()
    }
    
    func onDidChangeFavoriteList() {
        let viewModels: [CryptoInfoViewModel] = cryptoList.map { crypto -> CryptoInfoViewModel in
            let url = URL(string: crypto.icon ?? "")
            return CryptoInfoViewModel(iconURL: url,
                                       name: crypto.name,
                                       base: crypto.base?.uppercased(),
                                       salePrice: crypto.sell,
                                       buyPrice: crypto.buy,
                                       isFavorite: crypto.isFavorite)
        }
        DispatchQueue.main.async { [weak view] in
            view?.viewModels.accept(viewModels)
        }
    }
}
