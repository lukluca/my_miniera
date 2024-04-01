//
//  CoinMarketChartObservable.swift
//  MyMiniera
//
//  Created by lukluca on 31/03/24.
//

import Foundation
import Combine

class CoinMarketChartObservable: ObservableObject {
    
    private var cancellables = Set<AnyCancellable>()
    
    @Published var value: CoinMarketChart?
    @Published var error: Error?
    
    init() {}
    
    func fetch(coinId: String) {
        let parameters = CoinsMarketChartParameters(currency: Network.CoinGecko.euro,
                                                    days: 7,
                                                    interval: .daily,
                                                    precision: nil)
        Network.CoinGecko.coinsMarketChart(id: coinId, parameters: parameters).fetch()
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .failure(let error):
                    self?.error = error
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] market in
                self?.value = market
            })
            .store(in: &cancellables)
    }
}
