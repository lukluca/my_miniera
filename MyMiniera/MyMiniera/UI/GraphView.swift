//
//  GraphView.swift
//  MyMiniera
//
//  Created by lukluca on 01/04/24.
//

import Charts
import SwiftUI

struct GraphView: View {
    
    let data: [Item]
    
    var body: some View {
        Chart {
            ForEach(data) { series in
                ForEach(series.prices, id: \.day) { element in
                    LineMark(
                        x: .value("Day", element.day, unit: .day),
                        y: .value("Price", element.price)
                    )
                }
                .foregroundStyle(by: .value("Coin", series.coinId))
                .symbol(by: .value("Coin", series.coinId))
                .interpolationMethod(.linear)
            }
        }
        .chartYScale(domain: .automatic(includesZero: false))
    }
}

extension GraphView {
    struct Item: Identifiable {
        let coinId: String
        let prices: [(day: Date, price: Double)]

        var id: String { coinId }
    }
}

extension GraphView.Item {
    static let loading = Self.init(coinId: "loading", prices: [(day: Date(), price: 12345)])
}
