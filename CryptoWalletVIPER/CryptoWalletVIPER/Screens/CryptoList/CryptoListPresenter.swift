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
}

final class CryptoListPresenter: CryptoListPresentable {
    
    private let view: CryptoListViewable!
    private let interactor: CryptoListInteractable
    private let router: CryptoListRoutable
    private let disposeBag = DisposeBag()
    
    private var viewModels = [CryptoInfoViewModel]()
    
    init(view: CryptoListViewController, interactor: CryptoListInteractable, router: CryptoListRoutable) {
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
    
    private func configurePresenter() {
        Observable
            .merge(viewDidLoadRelay.asObservable(), refreshDataRelay.asObservable())
            .subscribe(onNext: { [weak interactor] in
            interactor?.getCryptoList()
        }).disposed(by: disposeBag)

        filterTextRelay
            .compactMap { [weak self] filter in
                self?.viewModels.filter { ($0.base ?? "").uppercased().contains(filter) || ($0.name ?? "").uppercased().contains(filter) }
            }
            .bind(to: view.viewModels)
            .disposed(by: disposeBag)
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
                                       buyPrice: crypto.buy)
        }
        self.viewModels = viewModels
        DispatchQueue.main.async { [weak view] in
            view?.endRefreshing()
            view?.viewModels.accept(viewModels)
        }
    }
    
    func onSearchError(_ error: Error) {
        DispatchQueue.main.async { [weak view] in
            view?.endRefreshing()
        }
        print(error.localizedDescription)
    }
}
