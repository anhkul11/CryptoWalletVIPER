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
    
    var isFavorite: Bool {
        let favoriteList = UserDefaults.standard.stringArray(forKey: UserDefaultKeys.favoritesCryptoList) ?? []
        return favoriteList.contains(base ?? "")
    }
    
    static func changeFavorite(for cryptoBase: String) {
        guard var favoriteList = UserDefaults.standard.stringArray(forKey: UserDefaultKeys.favoritesCryptoList) else {
            let favorites = [cryptoBase]
            UserDefaults.standard.setValue(favorites, forKey: UserDefaultKeys.favoritesCryptoList)
            return
        }
        if favoriteList.contains(cryptoBase) {
            favoriteList.removeAll(where: { $0 == cryptoBase })
        } else {
            favoriteList.append(cryptoBase)
        }
        UserDefaults.standard.setValue(favoriteList, forKey: UserDefaultKeys.favoritesCryptoList)
    }
}

struct CryptoListResponse: Codable {
    let cryptos: [Crypto]
    
    enum CodingKeys: String, CodingKey {
        case cryptos = "data"
    }
}
