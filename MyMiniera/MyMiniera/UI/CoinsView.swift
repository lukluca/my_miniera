//
//  CoinsView.swift
//  MyMiniera
//
//  Created by lukluca on 27/03/24.
//

import SwiftUI
import Combine

struct CoinsView: View {
    
    @ObservedObject var viewModel = ViewModel()
    
    var body: some View {
        NavigationView {
            switch viewModel.state {
            case .initial:
                EmptyView()
            case .loading:
                ProgressView()
            case .successfullyFetched(let models):
                List(models, id: \.id) { coin in
                    
                    NavigationLink(destination: DetailView(viewModel: .init(coin: coin))) {
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
                .navigationTitle("My Miniera")
                .refreshable {
                    viewModel.fetch()
                }
            case .noResultsFound:
                Text("Nothing found!")
                    .navigationTitle("My Miniera")
            case .tooManyRequest:
                Button("Too many request, please retry later!") {
                    viewModel.fetch()
                }
            case .failure:
                Button("Something went wrong, please retry!") {
                    viewModel.fetch()
                }
                .navigationTitle("My Miniera")
            }
        }
        .onAppear {
            viewModel.fetch()
        }
    }
}

extension CoinsView {
    class ViewModel: ObservableObject {
        
        private var cancellables = Set<AnyCancellable>()
        
        @Published var state: State = .initial
        
        private let coinsList = CoinsMarketsObservable()
        
        init() {
            coinsList.$values
                .compactMap {$0}
                .sink { [weak self] list in
                    if list.isEmpty {
                        self?.state = .noResultsFound
                    } else {
                        self?.state = .successfullyFetched(list)
                    }
                }
                .store(in: &cancellables)
            
            coinsList.$error
                .compactMap {$0}
                .sink { [weak self] error in
                    debugPrint(error.localizedDescription)
                    
                    switch error {
                    case let networkError as Network.NetworkError:
                        switch networkError {
                        case .invalid(statusCode: let code) where code == 429:
                            self?.state = .tooManyRequest
                        default:
                            self?.state = .failure(error)
                        }
                    default:
                        self?.state = .failure(error)
                    }
                }
            .store(in: &cancellables)
        }
        
        func fetch() {
            state = .loading
            coinsList.fetch()
        }
    }
}

extension CoinsView.ViewModel {
    enum State {
        case initial
        case loading
        case successfullyFetched([CoinMarket])
        case noResultsFound
        case tooManyRequest
        case failure(Error)
    }
}

extension CoinsView {
    
    struct Item: View {
        
        let coin: CoinMarket
        
        var body: some View {
            VStack(alignment: .leading) {
                HStack {
                    Text(coin.name)
                        .fontWeight(.heavy)
                    Text(coin.symbol)
                        .fontWeight(.ultraLight)
                }
                HStack {
                    AsyncImage(url: coin.image) { image in
                        image.resizable()
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: 50, height: 50)
                    
                    CurrentPrice(currentPrice: coin.currentPrice,
                                 isBull: coin.isBull)
                }
                .padding(.bottom, 7)
            }
        }
    }
}
