//
//  CryptoListPresenter.swift
//  CryptoWalletVIPER
//
//  Created by Le Quoc Anh on 5/25/21.
//

import Foundation

protocol CryptoListPresentable: Presentable {
    var viewDidLoadRelay: PublishRelay<Void> { get }
}

final class CryptoListPresenter: CryptoListPresentable {
    
    private let view: CryptoListViewable!
    private let interactor: CryptoListInteractable
    private let router: CryptoListRoutable
    private let disposeBag = DisposeBag()
    
    init(view: CryptoListViewController, interactor: CryptoListInteractable, router: CryptoListRoutable) {
        self.view = view
        self.interactor = interactor
        self.router = router
        view.presenter = self
        interactor.presenter = self
        
        configurePresenter()
    }
    
    let viewDidLoadRelay = PublishRelay<Void>()
    
    private func configurePresenter() {
        viewDidLoadRelay.subscribe(onNext: { [weak interactor] in
            interactor?.getCryptoList()
        }).disposed(by: disposeBag)

    }
}

extension CryptoListPresenter: CryptoListInteractableListener {
    func onSearchCryptoListSuccess(_ cryptoList: [Crypto]) {
        let viewModels: [CryptoInfoViewModel] = cryptoList.map { crypto in
            let url = URL(string: crypto.icon ?? "")
            return CryptoInfoViewModel(iconURL: url,
                                       name: crypto.name,
                                       base: crypto.base?.capitalized,
                                       salePrice: crypto.sell,
                                       buyPrice: crypto.buy)
        }
        DispatchQueue.main.async { [weak view] in
            view?.reloadTableView(with: viewModels)
        }
    }
    
    func onSearchError(_ error: Error) {
        print(error.localizedDescription)
    }
}
