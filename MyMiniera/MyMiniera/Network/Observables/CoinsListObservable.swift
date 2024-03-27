//
//  CoinsListObservable.swift
//  MyMiniera
//
//  Created by softwave on 27/03/24.
//

import Foundation
import Combine

class CoinsListObservable: ObservableObject {
    
    private var cancellables = Set<AnyCancellable>()
    
    @Published var values: [CoinsList] = []
    @Published var error: Error?
    
    init() {}
    
    func fetch() {
        Network.CoinGecko.coinsList(includePlatform: nil).fetch()
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
        }).store(in: &cancellables)
    }
}
