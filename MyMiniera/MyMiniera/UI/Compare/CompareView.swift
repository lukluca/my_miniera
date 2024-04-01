//
//  CompareView.swift
//  MyMiniera
//
//  Created by softwave on 01/04/24.
//

import Combine
import SwiftUI

struct CompareView: View {
    
    @ObservedObject var viewModel: ViewModel
    
    @State private var selectedCoin = "Coin"
    
    var body: some View {
        VStack {
            HStack {
                Text("Compare")
                Text(viewModel.coin.name)
                Text("with")
                
                Picker("Coin", selection: $selectedCoin) {
                    if selectedCoin == "Coin" {
                        Text("Select coin...").tag("Coin")
                    }
                    
                    ForEach(viewModel.otherCoins) {
                        Text($0.name).tag($0.name)
                    }
                }
                
                
            }
            
            switch viewModel.state {
            case .initial:
                Spacer()
            case .loading:
                GraphView(data: [])
                    .redacted(reason: .placeholder)
            case .successfullyFetched(let marketData):
                GraphView(data: [viewModel.coinGraph, marketData])
                    .padding(10)
            case .noResultsFound:
                Spacer()
                Text("No data market available!")
                Spacer()
            case .tooManyRequest:
                Spacer()
                ErrorView(isTooManyRequest: true, action: {
                    viewModel.fetch(name: selectedCoin)
                })
                Spacer()
            case .failure:
                Spacer()
                ErrorView(isTooManyRequest: false, action: {
                    viewModel.fetch(name: selectedCoin)
                })
                Spacer()
            }
        }
        .navigationTitle("Compare")
        .onChange(of: selectedCoin) { (_, selected) in
            viewModel.fetch(name: selected)
        }
    }
}

extension CompareView {
    class ViewModel: ObservableObject {
        let coin: CoinMarket
        let coinGraph: GraphView.Item
        let otherCoins: [CoinMarket]
        
        private var otherSelectedCoin: String = ""
        
        @Published var state: State
        
        private var cancellables = Set<AnyCancellable>()
        private let coinsMarkets = CoinMarketChartObservable()
        
        init(coin: CoinMarket, 
             coinGraph: GraphView.Item,
             otherCoins: [CoinMarket],
             state: State = .initial) {
            self.coin = coin
            self.coinGraph = coinGraph
            self.otherCoins = otherCoins
            self.state = state
            
            coinsMarkets.$value
                .compactMap {$0}
                .sink { [weak self] marketDatas in
                    
                    guard let self else {
                        return
                    }
                    
                    self.state = marketDatas.areAllPricesEmpty ? .noResultsFound : .successfullyFetched(marketDatas.priceChartItems(coinId: self.otherSelectedCoin))
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
        
        func fetch(name: String) {
            guard !ProcessInfo.isOnPreview() else {
                return
            }
            
            let selected = otherCoins.first { $0.name == name }
            
            guard let selected else {
                return
            }
            
            otherSelectedCoin = selected.id
            
            state = .loading
            coinsMarkets.fetch(coinId: selected.id)
        }
    }
}

// MARK: State

extension CompareView.ViewModel {
    enum State {
        case initial
        case loading
        case successfullyFetched(GraphView.Item)
        case noResultsFound
        case tooManyRequest
        case failure
    }
}

// MARK: Preview

#Preview("Initial") {
    CompareView(viewModel: .init(coin: .bitcoin,
                                 coinGraph: CoinMarketChart.preview.priceChartItems(coinId: "bitcoin"),
                                 otherCoins: [.bitcoin],
                                 state: .initial))
}

#Preview("Loading") {
    CompareView(viewModel: .init(coin: .bitcoin,
                                 coinGraph: CoinMarketChart.preview.priceChartItems(coinId: "bitcoin"),
                                 otherCoins: [.bitcoin],
                                 state: .loading))
}

#Preview("Success") {
    CompareView(viewModel: .init(coin: .bitcoin,
                                 coinGraph: CoinMarketChart.preview.priceChartItems(coinId: "bitcoin"),
                                 otherCoins: [.bitcoin],
                                 state: .successfullyFetched(GraphView.Item(coinId: "ethereum", prices: []))))
}

#Preview("No data") {
    CompareView(viewModel: .init(coin: .bitcoin,
                                 coinGraph: CoinMarketChart.preview.priceChartItems(coinId: "bitcoin"),
                                 otherCoins: [.bitcoin],
                                 state: .noResultsFound))
}

#Preview("Too many request") {
    CompareView(viewModel: .init(coin: .bitcoin,
                                 coinGraph: CoinMarketChart.preview.priceChartItems(coinId: "bitcoin"),
                                 otherCoins: [.bitcoin],
                                 state: .tooManyRequest))
}

#Preview("Failure") {
    CompareView(viewModel: .init(coin: .bitcoin,
                                 coinGraph: CoinMarketChart.preview.priceChartItems(coinId: "bitcoin"),
                                 otherCoins: [.bitcoin],
                                 state: .failure))
}
