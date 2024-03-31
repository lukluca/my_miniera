//
//  CoinsView.swift
//  MyMiniera
//
//  Created by lukluca on 27/03/24.
//

import SwiftUI
import Combine

struct CoinsView: View {
    
    @ObservedObject var viewModel: ViewModel
    
    init(viewModel: CoinsView.ViewModel = ViewModel()) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationView {
            Group {
                switch viewModel.state {
                case .initial:
                    EmptyView()
                       
                case .loading:
                    ProgressView()
                case .successfullyFetched(let models):
                    List(models, id: \.id) { coin in
                        
                        NavigationLink(destination: DetailView(coin: coin)) {
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
                case .tooManyRequest:
                    Button("Too many request, please retry later!") {
                        viewModel.fetch()
                    }
                case .failure:
                    Button("Something went wrong, please retry!") {
                        viewModel.fetch()
                    }
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
    class ViewModel: ObservableObject {
        
        private var cancellables = Set<AnyCancellable>()
        
        @Published var state: State
        
        private let coinsList = CoinsMarketsObservable()
        
        init(state: State = .initial) {
        
            self.state = state
            
            coinsList.$values
                .compactMap {$0}
                .sink { [weak self] list in
                    self?.state = list.isEmpty ? .noResultsFound : .successfullyFetched(list)
                }
                .store(in: &cancellables)
            
            coinsList.$error
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
        case failure
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
    CoinsView(viewModel: .init(state: .initial))
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
    CoinsView(viewModel: .init(state: .tooManyRequest))
}

#Preview("Failure") {
    CoinsView(viewModel: .init(state: .failure))
}
