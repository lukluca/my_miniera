//
//  CoinsMarketChartParameters.swift
//  MyMiniera
//
//  Created by lukluca on 31/03/24.
//

import Foundation

struct CoinsMarketChartParameters {
    let currency: String
    let days: Int
    let interval: Interval?
    let precision: String?
}

extension CoinsMarketChartParameters {
    enum Interval: String {
        case daily
    }
}
