//
//  VIPERBuilder.swift
//  CryptoWalletVIPER
//
//  Created by Le Quoc Anh on 5/25/21.
//

import Foundation
import UIKit

final class VIPERBuilder {
    
    static func buildCryptoList() -> UIViewController {
        let view = CryptoListViewController.initialInstantiate()
        let interactor = CryptoListInteractor()
        let router = CryptoListRouter(view: view)
        let presenter = CryptoListPresenter(view: view,
                                            interactor: interactor,
                                            router: router)
        interactor.presenter = presenter
        return UINavigationController(rootViewController: view)
    }
}
