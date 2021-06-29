//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

protocol CoinManagerDelegate {
    func updateCoinPrice(_ coinManager: CoinManager, price: String, currency: String)
    func didFailWithError(_ coinManager: CoinManager, error: Error)
}

struct CoinManager {
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "API_KEY"
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    var delegate: CoinManagerDelegate?

    func getCoinPrice(for currency: String) {
        let url = baseURL + "/" + currency
        let params = ["apiKey": apiKey]
        AF.request(url, method: .get, parameters: params).responseJSON { response in
            if let error = response.error {
                self.delegate?.didFailWithError(self, error: error)
                return
            }
            if let safeData = response.data {
                do {
                    let json = try JSON(data: safeData)
                    print(json)
                    guard let priceString = parseJSON(json) else {
                        self.delegate?.didFailWithError(self, error: "Error parsing JSON" as! Error)
                        return
                    }
                    self.delegate?.updateCoinPrice(self, price: priceString, currency: currency)
                } catch {
                    print(error)
                }
            }
        }
    }
    
    func parseJSON(_ json: JSON) -> String? {
        if let price = json["rate"].double {
            let priceString = String(format: "%0.2f", price)
            return priceString
        }
        return nil
    }
}
