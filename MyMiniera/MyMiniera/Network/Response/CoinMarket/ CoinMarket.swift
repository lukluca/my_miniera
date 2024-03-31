//
//   CoinMarket.swift
//  MyMiniera
//
//  Created by lukluca on 28/03/24.
//

import Foundation

struct CoinMarket {
    let id: String
    let symbol: String
    let name: String
    let image: URL
    let marketCap: Double
    let currentPrice: Double
    let priceChangePercentage24h: Double
    let lastUpdated: Date
}

extension CoinMarket: Decodable {
    enum CodingKeys: String, CodingKey {
        case id
        case symbol
        case name
        case image
        case marketCap = "market_cap"
        case currentPrice = "current_price"
        case priceChangePercentage24h = "price_change_percentage_24h"
        case lastUpdated = "last_updated"
    }
}
