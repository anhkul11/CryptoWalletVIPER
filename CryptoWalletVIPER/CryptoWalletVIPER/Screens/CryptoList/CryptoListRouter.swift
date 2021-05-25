//
//  CryptoListRouter.swift
//  CryptoWalletVIPER
//
//  Created by Le Quoc Anh on 5/25/21.
//

import Foundation
import UIKit

protocol CryptoListRoutable: Routable {
}

final class CryptoListRouter: CryptoListRoutable {
    var view: Viewable!
    
    init(view: Viewable) {
        self.view = view
    }
}
