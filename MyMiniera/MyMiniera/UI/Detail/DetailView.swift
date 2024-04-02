//
//  DetailView.swift
//  MyMiniera
//
//  Created by lukluca on 29/03/24.
//

import SwiftUI

struct DetailView: View {
    
    @ObservedObject var viewModel: ViewModel
    
    init(coin: CoinMarket,
         otherCoins: [CoinMarket],
         state: ViewModel.State = .initial,
         errorState: ErrorView.State = .hidden) {
        self.viewModel = ViewModel(coin: coin,
                                   otherCoins: otherCoins,
                                   state: state,
                                   errorState: errorState)
    }
    
    var body: some View {
        List {
            Section {
                Image(url: viewModel.coin.image)
                .listRowBackground(Color.clear)
            }
            
            Section {
                ErrorView(state: $viewModel.errorState, action: viewModel.fetch)
            }
            
            Section {
                Description(description: viewModel.description, 
                            redactionReasons: viewModel.redactionReasons)
                .listRowBackground(viewModel.coin.color)
               
            } header: {
                Text("Description")
            }
            
            if let url = viewModel.homepageURL {
                Section {
                    Homepage(redactionReasons: viewModel.redactionReasons,
                             linkText: viewModel.homepageText,
                             linkURL: url)
                    .listRowBackground(viewModel.coin.color)
                   
                } header: {
                    Text("Homepage")
                }
            }
            
            Section {
                MarketData(coin: viewModel.coin)
                    .listRowBackground(viewModel.coin.color)
            } header: {
                Text("Market data")
            }
            
            Section {
                Graph(viewModel: viewModel.graph)
                    .listRowBackground(viewModel.coin.color)
            } header: {
                Text("Graph")
            }
        }
        .navigationTitle(viewModel.coin.name)
        .toolbar {
            ToolbarItemGroup(placement: .topBarTrailing) {
                if case let .successfullyFetched(coinGraph) = viewModel.graph.state {
                    NavigationLink(destination: CompareView(viewModel: .init(coin: viewModel.coin,
                                                                             coinGraph: coinGraph,
                                                                             otherCoins: viewModel.otherCoins))) {
                        Text("Compare")
                    }
                }
            }
        }
        .onAppear {
            viewModel.fetch()
        }
    }
}

// MARK: Preview

#Preview("Initial") {
    DetailView(coin: .bitcoin, otherCoins: [], state: .initial)
}

#Preview("Loading") {
    DetailView(coin: .bitcoin, otherCoins: [], state: .loading)
}

#Preview("Successfully fetched") {
    DetailView(coin: .bitcoin, otherCoins: [], state: .successfullyFetched(.bitcoin))
}

#Preview("Too many request") {
    DetailView(coin: .bitcoin, otherCoins: [.bitcoin], 
               state: .initial,
               errorState: .tooManyRequest)
}

#Preview("Failure") {
    DetailView(coin: .bitcoin, otherCoins: [.bitcoin], 
               state: .initial,
               errorState: .generalFailure)
}
