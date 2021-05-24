//
//  Presentable.swift
//  CryptoWalletVIPER
//
//  Created by Anh Lê on 5/24/21.
//

import Foundation

protocol Presentable {
  var view: Viewable { get }
  var interactor: Interactable { get }
  var router: Routable { get }
}
