//
//  DetailView.swift
//  MyMiniera
//
//  Created by lukluca on 29/03/24.
//

import SwiftUI

struct DetailView: View {
    
    @ObservedObject var viewModel: ViewModel
    
    init(coin: CoinMarket, state: ViewModel.State = .initial) {
        self.viewModel = ViewModel(coin: coin, state: state)
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
            
        }
        .navigationTitle(viewModel.coin.name)
        .onAppear {
            viewModel.fetch()
        }
    }
}

// MARK: Preview

#Preview("Initial") {
    DetailView(coin: .bitcoin, state: .initial)
}

#Preview("Loading") {
    DetailView(coin: .bitcoin, state: .loading)
}

#Preview("Successfully fetched") {
    DetailView(coin: .bitcoin, state: .successfullyFetched(.bitcoin))
}

#Preview("Too many request") {
    DetailView(coin: .bitcoin, state: .tooManyRequest)
}

#Preview("Failure") {
    DetailView(coin: .bitcoin, state: .failure)
}
