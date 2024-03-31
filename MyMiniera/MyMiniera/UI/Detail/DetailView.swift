//
//  DetailView.swift
//  MyMiniera
//
//  Created by lukluca on 29/03/24.
//

import SwiftUI

struct DetailView: View {
    
    @ObservedObject var viewModel: ViewModel
    
    @State private var tooManyRequestHappen = false
    @State private var failureHappen = false
    
    init(coin: CoinMarket,
         otherCoins: [CoinMarket],
         state: ViewModel.State = .initial) {
        self.viewModel = ViewModel(coin: coin, otherCoins: otherCoins, state: state)
    }
    
    var body: some View {
        List {
            Section {
                Image(url: viewModel.coin.image)
                .listRowBackground(Color.clear)
            }
            
            if let isTooManyRequest = viewModel.isOnTooManyRequestError {
                Section {
                    ErrorView(isTooManyRequest: isTooManyRequest,
                          action: viewModel.fetch)
                }
            }
            
            if tooManyRequestHappen {
                Section {
                    ErrorView(isTooManyRequest: true,
                          action: viewModel.fetchGraph)
                }
            }
            
            if failureHappen {
                Section {
                    ErrorView(isTooManyRequest: false,
                          action: viewModel.fetchGraph)
                }
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
                Graph(viewModel: viewModel.graph,
                      tooManyRequestHappen: $tooManyRequestHappen,
                      failureHappen: $failureHappen)
                    .listRowBackground(viewModel.coin.color)
            } header: {
                Text("Graph")
            }
        }
        .navigationTitle(viewModel.coin.name)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Compare") {
                    
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
    DetailView(coin: .bitcoin, otherCoins: [], state: .tooManyRequest)
}

#Preview("Failure") {
    DetailView(coin: .bitcoin, otherCoins: [], state: .failure)
}
