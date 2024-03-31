//
//  CoinsMarketsObservable.swift
//  MyMiniera
//
//  Created by lukluca on 28/03/24.
//

import Foundation
import Combine

class CoinsMarketsObservable: ObservableObject {
    
    private var cancellables = Set<AnyCancellable>()
    
    @Published var values: [CoinMarket]?
    @Published var error: Error?
    
    init() {}
    
    func fetch() {
        let parameters = CoinsMarketsParameters(currency: Network.CoinGecko.euro,
                                                order: .marketCapDesc,
                                                perPage: 10,
                                                page: 1)
        Network.CoinGecko.coinsMarkets(parameters: parameters).fetch()
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .failure(let error):
                    self?.error = error
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] coinsList in
                self?.values = coinsList
            })
            .store(in: &cancellables)
    }
}

