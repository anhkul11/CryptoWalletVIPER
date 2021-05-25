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

struct CryptoListResponse: Codable {
    let cryptos: [Crypto]
    
    enum CodingKeys: String, CodingKey {
      case cryptos = "data"
    }
}
