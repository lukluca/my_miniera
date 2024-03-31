//
//  CoinsObservable.swift
//  MyMiniera
//
//  Created by lukluca on 28/03/24.
//

import Foundation
import Combine

class CoinsObservable: ObservableObject {
    
    private var cancellables = Set<AnyCancellable>()
    
    @Published var value: Coin?
    @Published var error: Error?
    
    init() {}
    
    func fetch(coinId: String) {
        let parameters = CoinsParameters(localization: nil,
                                         tickers: false,
                                         marketData: false,
                                         communityData: false,
                                         developerData: false,
                                         sparkline: false)
        Network.CoinGecko.coins(id: coinId, parameters: parameters).fetch()
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .failure(let error):
                    self?.error = error
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] coin in
                self?.value = coin
            })
            .store(in: &cancellables)
    }
}
