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
        
        @Binding var tooManyRequestHappen: Bool
        @Binding var failureHappen: Bool
        
        var body: some View {
            
            VStack {
                switch viewModel.state {
                case .initial:
                    EmptyView()
                case .loading:
                    GraphView(data: [])
                        .redacted(reason: .placeholder)
                case .successfullyFetched(let marketData):
                    GraphView(data: [marketData])
                        .padding(10)
                case .noResultsFound:
                    Text("No data market available!")
                case .tooManyRequest, .failure:
                    Text("Error! No data to show")
                }
            }
            .onChange(of: viewModel.state) { (_, state) in
                switch state {
                case .tooManyRequest:
                    tooManyRequestHappen = true
                case .failure:
                    failureHappen = true
                default:
                    break
                }
            }
            .onAppear {
                viewModel.fetch()
            }
        }
    }
}

extension DetailView.Graph {
    class ViewModel: ObservableObject {
        
        let coinId: String
        
        @Published var state: State
    
        private var cancellables = Set<AnyCancellable>()
        private let coinsMarkets = CoinMarketChartObservable()
        
        init(coinId: String, state: State = .initial) {
            
            self.coinId = coinId
            self.state = state
            
            coinsMarkets.$value
                .compactMap {$0}
                .sink { [weak self] marketDatas in
                    
                    self?.state = marketDatas.areAllPricesEmpty ? .noResultsFound : .successfullyFetched(marketDatas.priceChartItems(coinId: coinId))
                }
                .store(in: &cancellables)
            
            coinsMarkets.$error
                .compactMap {$0}
                .sink { [weak self] error in
                    debugPrint(error.localizedDescription)
                    self?.state = error.isTooManyRequest ? .tooManyRequest : .failure
                }
                .store(in: &cancellables)
        }
        
        func fetch() {
            guard !ProcessInfo.isOnPreview() else {
                return
            }
            state = .loading
            coinsMarkets.fetch(coinId: coinId)
        }
    }
}

// MARK: State
extension DetailView.Graph.ViewModel {
    enum State: Equatable {
        case initial
        case loading
        case successfullyFetched(GraphView.Item)
        case noResultsFound
        case tooManyRequest
        case failure
        
        static func == (lhs: State, rhs: State) -> Bool {
            switch (lhs, rhs) {
            case (.initial, .initial):
                true
            case (.loading, .loading):
                true
            case (.successfullyFetched, .successfullyFetched):
                true
            case (.noResultsFound, .noResultsFound):
                true
            case (.tooManyRequest, .tooManyRequest):
                true
            case (.failure, .failure):
                true
            default:
                false
            }
        }
    }
}

// MARK: Preview

#Preview("Initial") {
    DetailView.Graph(viewModel: .init(coinId: "bitcoin", state: .initial),
                     tooManyRequestHappen: .constant(false),
                     failureHappen: .constant(false))
}

#Preview("Loading") {
    DetailView.Graph(viewModel: .init(coinId: "bitcoin", state: .loading),
                     tooManyRequestHappen: .constant(false),
                     failureHappen: .constant(false))
}

#Preview("Successfully fetched") {
    DetailView.Graph(viewModel: .init(coinId: "bitcoin",
                                      state: .successfullyFetched(CoinMarketChart.preview.priceChartItems(coinId: "bitcoin"))),
                     tooManyRequestHappen: .constant(false),
                     failureHappen: .constant(false))
}

#Preview("No results found") {
    DetailView.Graph(viewModel: .init(coinId: "bitcoin",
                                      state: .noResultsFound),
                     tooManyRequestHappen: .constant(false),
                     failureHappen: .constant(false))
}

#Preview("Too many request") {
    DetailView.Graph(viewModel: .init(coinId: "bitcoin",
                                      state: .tooManyRequest),
                     tooManyRequestHappen: .constant(false),
                     failureHappen: .constant(false))
}

#Preview("Failure") {
    DetailView.Graph(viewModel: .init(coinId: "bitcoin",
                                      state: .failure),
                     tooManyRequestHappen: .constant(false),
                     failureHappen: .constant(false))
}

private extension CoinMarketChart {
    
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
