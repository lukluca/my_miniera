//
//   CoinMarket.swift
//  MyMiniera
//
//  Created by lukluca on 28/03/24.
//

import Foundation

struct CoinMarket: Decodable {
    let id: String
    let symbol: String
    let name: String
    let image: URL
    let currentPrice: Double
    let priceChangePercentage24h: Double
}

extension CoinMarket {
    enum CodingKeys: String, CodingKey {
        case id
        case symbol
        case name
        case image
        case currentPrice = "current_price"
        case priceChangePercentage24h = "price_change_percentage_24h"
    }
}
