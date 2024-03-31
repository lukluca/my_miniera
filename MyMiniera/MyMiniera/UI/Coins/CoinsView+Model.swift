//
//  CoinsView+Model.swift
//  MyMiniera
//
//  Created by softwave on 31/03/24.
//

import Foundation
import Combine

extension CoinsView {
    class ViewModel: ObservableObject {
        
        @Published var state: State
        @Published var errorStare: ErrorState
        
        private var cancellables = Set<AnyCancellable>()
        private let coinsList = CoinsMarketsObservable()
        
        init(state: State = .initial, errorState: ErrorState = .initial) {
            
            self.state = state
            self.errorStare = errorState
            
            coinsList.$values
                .compactMap {$0}
                .sink { [weak self] list in
                    self?.apply(list: list)
                }
                .store(in: &cancellables)
            
            coinsList.$error
                .compactMap {$0}
                .sink { [weak self] error in
                    debugPrint(error.localizedDescription)
                    self?.apply(error: error)
                    if let list = self?.coinsList.values {
                        self?.apply(list: list)
                    }
                }
                .store(in: &cancellables)
        }
        
        func fetch() {
            guard !ProcessInfo.isOnPreview() else {
                return
            }
            state = .loading
            errorStare = .initial
            coinsList.fetch()
        }
        
        private func apply(list: [CoinMarket]) {
            state = list.isEmpty ? .noResultsFound : .successfullyFetched(list)
        }
        
        private func apply(error: Error) {
            errorStare = error.isTooManyRequest ? .tooManyRequest : .generalFailure
        }
    }
}

// MARK: State
extension CoinsView.ViewModel {
    enum State {
        case initial
        case loading
        case successfullyFetched([CoinMarket])
        case noResultsFound
    }
    
    enum ErrorState {
        case initial
        case tooManyRequest
        case generalFailure
    }
}
