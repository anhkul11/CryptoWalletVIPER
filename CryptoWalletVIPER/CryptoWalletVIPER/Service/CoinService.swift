//
//  CoinService.swift
//  CryptoWalletVIPER
//
//  Created by Le Quoc Anh on 5/25/21.
//

import Foundation

struct CoinService {
    private static var baseUrl = "https://www.coinhako.com/api/v3"
    
    struct SearchCoinRequest: Request {
        var url: String {
            return baseUrl + "/price/all_prices_for_mobile"
        }
        
        var counter: String = "USD"
        
        func params() -> [(key: String, value: String)] {
            return [
                (key: "counter_currency", value: counter)
            ]
        }
    }
    
    func search(with request: SearchCoinRequest, onSuccess: @escaping (CryptoListResponse) -> Void, onError: @escaping (Error) -> Void) {
        ServiceTask().request(.get, request: request, onSuccess: { (data, session) in
            do {
                let response = try self.parse(data)
                onSuccess(response)
            } catch {
                onError(ServiceError.failedParse)
            }
        }, onError: onError)
    }
    
    private func parse(_ data: Data) throws -> CryptoListResponse {
        let response: CryptoListResponse = try JSONDecoder().decode(CryptoListResponse.self, from: data)
        return response
    }
}
