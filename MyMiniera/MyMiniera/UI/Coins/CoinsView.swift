//
//  CoinsView.swift
//  MyMiniera
//
//  Created by lukluca on 27/03/24.
//

import SwiftUI

struct CoinsView: View {
    
    @ObservedObject var viewModel: ViewModel
    
    init(viewModel: CoinsView.ViewModel = ViewModel()) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                
                ErrorView(state: $viewModel.errorState,
                          action: viewModel.fetch)
                
                switch viewModel.state {
                case .initial:
                    EmptyView()
                case .loading:
                    ProgressView()
                case .successfullyFetched(let models):
                    List(models, id: \.id) { coin in
                        
                        NavigationLink(destination: DetailView(coin: coin, otherCoins: models.allExcluding(coinId: coin.id))) {
                            Item(coin: coin)
                        }
                        .listRowSeparator(.hidden)
                        .listRowBackground(
                            RoundedRectangle(cornerRadius: 5)
                                .background(.clear)
                                .foregroundStyle(coin.color)
                                .padding(
                                    EdgeInsets(
                                        top: 2,
                                        leading: 10,
                                        bottom: 2,
                                        trailing: 10
                                    )
                                )
                        )
                    }
                    .listStyle(.plain)
                    .refreshable {
                        viewModel.fetch()
                    }
                case .noResultsFound:
                    Text("Nothing found!")
                }
            }
            .navigationTitle("My Miniera")
        }
        .onAppear {
            viewModel.fetch()
        }
    }
}

extension CoinsView {
    struct Item: View {
        
        let coin: CoinMarket
        
        var body: some View {
            HStack {
                AsyncImage(url: coin.image) { image in
                    image.resizable()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 50, height: 50)
                
                VStack(alignment: .leading) {
                    HStack {
                        Text(coin.name)
                            .fontWeight(.heavy)
                        Text(coin.symbol)
                            .fontWeight(.ultraLight)
                    }
                    
                    CurrentPrice(currentPrice: coin.currentPrice,
                                 isBull: coin.isBull)
                }
            }
        }
    }
}

// MARK: Preview

#Preview("Initial") {
    CoinsView(viewModel: .init(state: .initial, errorState: .hidden))
}

#Preview("Loading") {
    CoinsView(viewModel: .init(state: .loading))
}

#Preview("Successfully fetched") {
    CoinsView(viewModel: .init(state: .successfullyFetched(.preview)))
}

#Preview("No results found") {
    CoinsView(viewModel: .init(state: .noResultsFound))
}

#Preview("Too many request") {
    CoinsView(viewModel: .init(errorState: .tooManyRequest))
}

#Preview("Failure") {
    CoinsView(viewModel: .init(errorState: .generalFailure))
}

#Preview("Failure with success") {
    CoinsView(viewModel: .init(state: .successfullyFetched(.preview),
                               errorState: .generalFailure))
}
