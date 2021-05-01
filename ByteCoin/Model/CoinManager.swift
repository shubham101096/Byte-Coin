//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation
import Alamofire

protocol CoinManagerDelegate {
    func updateCoinPrice(_ coinManager: CoinManager, price: String, currency: String)
    func didFailWithError(_ coinManager: CoinManager, error: Error)
}

struct CoinManager {
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "9649C778-E8AD-40E5-B6A2-4194BBA8392A"
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    var delegate: CoinManagerDelegate?

    func getCoinPrice(for currency: String) {
        let url = baseURL + "/" + currency
        let params = ["apiKey": apiKey]
        AF.request(url, method: .get, parameters: params).responseDecodable(of: CoinData.self) { response in
            if let error = response.error {
                self.delegate?.didFailWithError(self, error: error)
                return
            }

            print(response.value)
            
            if let rate = response.value?.rate {
                let priceString = String(format: "%0.2f", rate)
                self.delegate?.updateCoinPrice(self, price: priceString, currency: currency)
            }
        }
    }
}
