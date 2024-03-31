//
//  CoinMarketChart.swift
//  MyMiniera
//
//  Created by lukluca on 31/03/24.
//

import Foundation

struct CoinMarketChart: Decodable {
    let prices: [[Double]]
}

extension CoinMarketChart {
    var areAllPricesEmpty: Bool {
        prices.allSatisfy {
            $0.isEmpty
        }
    }
}
