//
//  UIViewController+Extension.swift
//  CryptoWalletVIPER
//
//  Created by Le Quoc Anh on 5/25/21.
//

import UIKit

extension UIViewController {
    static func initialInstantiate() -> Self {
        let storyBoard = UIStoryboard(name: String(describing: Self.self), bundle: nil)
        if #available(iOS 13.0, *) {
            return storyBoard.instantiateInitialViewController() ?? Self()
        } else {
            return storyBoard.instantiateInitialViewController() as! Self
        }
    }
}
