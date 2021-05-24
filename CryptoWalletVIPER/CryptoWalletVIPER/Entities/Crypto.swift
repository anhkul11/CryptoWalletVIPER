//
//  Crypto.swift
//  CryptoWalletVIPER
//
//  Created by Anh Lê on 5/24/21.
//

import Foundation

struct Crypto: Codable {
  var base: String?
  var name: String?
  var buy: String?
  var sell: String?
  var icon: String?
  var counter: String?
  
  enum CodingKeys: String, CodingKey {
    case base, name, icon, counter
    case buy = "buy_price"
    case sell = "sell_price"
  }
}
