//
//  MockCryptoListInteractor.swift
//  CryptoWalletVIPERTests
//
//  Created by Le Quoc Anh on 5/27/21.
//

import Foundation
@testable import CryptoWalletVIPER

class MockCryptoListInteractor: CryptoListInteractable {

    var invokedPresenterSetter = false
    var invokedPresenterSetterCount = 0
    var invokedPresenter: CryptoListInteractableListener?
    var invokedPresenterList = [CryptoListInteractableListener?]()
    var invokedPresenterGetter = false
    var invokedPresenterGetterCount = 0
    var stubbedPresenter: CryptoListInteractableListener!

    var presenter: CryptoListInteractableListener? {
        set {
            invokedPresenterSetter = true
            invokedPresenterSetterCount += 1
            invokedPresenter = newValue
            invokedPresenterList.append(newValue)
        }
        get {
            invokedPresenterGetter = true
            invokedPresenterGetterCount += 1
            return stubbedPresenter
        }
    }

    var invokedGetCryptoList = false
    var invokedGetCryptoListCount = 0

    func getCryptoList() {
        invokedGetCryptoList = true
        invokedGetCryptoListCount += 1
    }

    var invokedUpdateFavorite = false
    var invokedUpdateFavoriteCount = 0
    var invokedUpdateFavoriteParameters: (coinBase: String, Void)?
    var invokedUpdateFavoriteParametersList = [(coinBase: String, Void)]()

    func updateFavorite(for coinBase: String) {
        invokedUpdateFavorite = true
        invokedUpdateFavoriteCount += 1
        invokedUpdateFavoriteParameters = (coinBase, ())
        invokedUpdateFavoriteParametersList.append((coinBase, ()))
    }
}
