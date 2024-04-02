//
//  DetailView+Graph.swift
//  MyMiniera
//
//  Created by lukluca on 31/03/24.
//

import Charts
import SwiftUI
import Combine

extension DetailView {
    struct Graph: View {
        
        @ObservedObject var viewModel: ViewModel
        
        var body: some View {
            
            VStack {
                switch viewModel.state {
                case .initial:
                    EmptyView()
                case .loading:
                    GraphView(data: [.loading])
                        .redacted(reason: .placeholder)
                case .successfullyFetched(let marketData):
                    GraphView(data: [marketData])
                        .padding(10)
                case .noResultsFound:
                    Text("No data market available!")
                        .padding()
                }
            }
        }
    }
}

extension DetailView.Graph {
    class ViewModel: ObservableObject {
        
        let coinId: String
        
        @Published var state: State
        @Published var errorState: ErrorView.State
    
        private var cancellables = Set<AnyCancellable>()
        private let coinsMarkets = CoinMarketChartObservable()
        
        init(coinId: String, 
             state: State = .initial,
             errorState: ErrorView.State = .hidden) {
            
            self.coinId = coinId
            self.state = state
            self.errorState = errorState
            
            coinsMarkets.$value
                .compactMap {$0}
                .sink { [weak self] marketDatas in
                    self?.apply(marketDatas: marketDatas)
                }
                .store(in: &cancellables)
            
            coinsMarkets.$error
                .compactMap {$0}
                .sink { [weak self] error in
                    debugPrint(error.localizedDescription)
                    self?.errorState = error.isTooManyRequest ? .tooManyRequest : .generalFailure
                }
                .store(in: &cancellables)
        }
        
        func fetch() {
            guard !ProcessInfo.isOnPreview() else {
                return
            }
            state = .loading
            errorState = .hidden
            coinsMarkets.fetch(coinId: coinId)
        }
        
        private func apply(marketDatas: CoinMarketChart) {
            state = marketDatas.areAllPricesEmpty ? .noResultsFound : .successfullyFetched(marketDatas.priceChartItems(coinId: coinId))
        }
    }
}

// MARK: State
extension DetailView.Graph.ViewModel {
    enum State {
        case initial
        case loading
        case successfullyFetched(GraphView.Item)
        case noResultsFound
    }
}

// MARK: Preview

#Preview("Initial") {
    DetailView.Graph(viewModel: .init(coinId: "bitcoin", state: .initial))
}

#Preview("Loading") {
    DetailView.Graph(viewModel: .init(coinId: "bitcoin", state: .loading))
}

#Preview("Successfully fetched") {
    DetailView.Graph(viewModel: .init(coinId: "bitcoin",
                                      state: .successfullyFetched(.bitcoinPreview)))
}

#Preview("No results found") {
    DetailView.Graph(viewModel: .init(coinId: "bitcoin",
                                      state: .noResultsFound))
}

#Preview("Too many request") {
    DetailView.Graph(viewModel: .init(coinId: "bitcoin",
                                      state: .initial,
                                      errorState: .tooManyRequest))
}

#Preview("General Failure") {
    DetailView.Graph(viewModel: .init(coinId: "bitcoin",
                                      state: .initial,
                                      errorState: .generalFailure))
}

extension CoinMarketChart {
    
    func priceChartItems(coinId: String) -> GraphView.Item {
        
        let itemPrices: [(Date, Double)] = prices.compactMap { price in
            guard price.count >= 2 else {
                return nil
            }
        
            let date = Date(timeIntervalSince1970: TimeInterval(price[0]/1000))
            
            return (date, price[1])
        }
        
        return GraphView.Item(coinId: coinId, prices: itemPrices)
    }
}
