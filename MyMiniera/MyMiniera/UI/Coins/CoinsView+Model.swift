//
//  CoinsView+Model.swift
//  MyMiniera
//
//  Created by lukluca on 31/03/24.
//

import Foundation
import Combine

extension CoinsView {
    class ViewModel: ObservableObject {
        
        @Published var state: State
        @Published var errorState: ErrorView.State
        
        private var cancellables = Set<AnyCancellable>()
        private let coinsList = CoinsMarketsObservable()
        
        init(state: State = .initial, errorState: ErrorView.State = .hidden) {
            
            self.state = state
            self.errorState = errorState
           
            coinsList.$values
                .compactMap {$0}
                .sink { [weak self] list in
                    self?.errorState = .hidden
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
                    } else {
                        self?.state = .initial
                    }
                }
                .store(in: &cancellables)
        }
        
        func fetch() {
            guard !ProcessInfo.isOnPreview() else {
                return
            }
            state = .loading
            errorState = .hidden
            coinsList.fetch()
        }
        
        private func apply(list: [CoinMarket]) {
            state = list.isEmpty ? .noResultsFound : .successfullyFetched(list)
        }
        
        private func apply(error: Error) {
            errorState = error.isTooManyRequest ? .tooManyRequest : .generalFailure
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

extension Array where Element == CoinMarket {
    
    func allExcluding(coinId: String) -> Self {
        var mutable = self
        mutable.removeAll { $0.id == coinId }
        return mutable
    }
}
