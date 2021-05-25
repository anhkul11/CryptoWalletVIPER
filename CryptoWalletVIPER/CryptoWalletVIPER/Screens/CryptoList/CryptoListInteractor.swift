//
//  CryptoListInteractor.swift
//  CryptoWalletVIPER
//
//  Created by Le Quoc Anh on 5/25/21.
//

import Foundation

protocol CryptoListInteractableListener: class {
    func onSearchCryptoListSuccess(_ cryptoList: [Crypto])
    func onSearchError(_ error: Error)
}

protocol CryptoListInteractable: Interactable {
    var presenter: CryptoListInteractableListener? { get set }
    func getCryptoList()
}

final class CryptoListInteractor: CryptoListInteractable {
    weak var presenter: CryptoListInteractableListener?
    
    func getCryptoList() {
        let onSuccess: (CryptoListResponse) -> Void = { [weak presenter] response in
            presenter?.onSearchCryptoListSuccess(response.cryptos)
        }
        let onError: (Error) -> Void = { [weak presenter] error in
            presenter?.onSearchError(error)
        }
        CoinService().search(with: CoinService.SearchCoinRequest(), onSuccess: onSuccess, onError: onError)
    }
}

