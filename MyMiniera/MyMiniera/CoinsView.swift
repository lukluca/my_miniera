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
        Group {
            switch viewModel.state {
            case .initial:
                EmptyView()
            case .loading:
                ProgressView()
            case .successfullyFetched(let models):
                List(models) {
                    Text($0.name)
                }
            case .noResultsFound(let text):
                Text(text)
            case .failure(let errorMessage):
                Text(errorMessage)
            }
        }
        .padding()
        .onAppear {
            viewModel.fetch()
        }
    }
}

extension CoinsView {
    class ViewModel: ObservableObject {
        
        private var cancellables = Set<AnyCancellable>()
        
        @Published var state: State = .initial
        
        let coinsList = CoinsListObservable()
        
        init() {
            coinsList.$values
                .dropFirst(1)
                .map { values -> [SimpleCoin] in
                    values.map {
                        SimpleCoin(id: $0.id,
                                   name: $0.name,
                                   image: $0.symbol,
                                   price: "$")
                    }
                }
                .sink { [weak self] coins in
                    if coins.isEmpty {
                        self?.state = .noResultsFound("Nothing found!")
                    } else {
                        self?.state = .successfullyFetched(coins)
                    }
                }
                .store(in: &cancellables)
            
            coinsList.$error.compactMap {$0} .sink { [weak self] error in
                debugPrint(error.localizedDescription)
                self?.state = .failure("Something went wrong, please retry!")
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
        case successfullyFetched([SimpleCoin]) // List of matching Movies
        case noResultsFound(String)
        case failure(String)
    }
}

// MARK: Preview
#Preview {
    CoinsView()
}

struct SimpleCoin: Identifiable {
    let id: String
    let name: String
    let image: String
    let price: String
}
