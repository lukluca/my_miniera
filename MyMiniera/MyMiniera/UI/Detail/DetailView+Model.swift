//
//  DetailView+Model.swift
//  MyMiniera
//
//  Created by softwave on 31/03/24.
//

import SwiftUI
import Combine

extension DetailView {
    class ViewModel: ObservableObject {
        
        let coin: CoinMarket
        
        private var cancellables = Set<AnyCancellable>()
        
        @Published private var state: State
        
        @Published var isOnTooManyRequestError: Bool? = nil
        
        @Published var description: AttributedString = ""
        
        @Published var homepageText: String = ""
        @Published var homepageURL: URL?
        
        @Published var redactionReasons: RedactionReasons = .placeholder
        
        private let coins = CoinsObservable()
        
        init(coin: CoinMarket, state: State) {
            
            self.coin = coin
            self.state = state
            
            apply(state: state)
            
            coins.$value
                .compactMap {$0}
                .sink { [weak self] coin in
                    self?.state = .successfullyFetched(coin)
                }
                .store(in: &cancellables)
            
            coins.$error
                .compactMap {$0}
                .sink { [weak self] error in
                    debugPrint(error.localizedDescription)
                    self?.state = error.isTooManyRequest ? .tooManyRequest : .failure
                }
                .store(in: &cancellables)
            
            $state.sink { [weak self] state in
                self?.apply(state: state)
            }
            .store(in: &cancellables)
        }
        
        func fetch() {
            guard !ProcessInfo.isOnPreview() else {
                return
            }
            state = .loading
            coins.fetch(coinId: coin.id)
        }
        
        private func apply(state: State) {
            switch state {
            case .initial:
                isOnTooManyRequestError = nil
                description = ""
                homepageText = ""
                homepageURL = nil
                redactionReasons = .placeholder
            case .loading:
                homepageText = "loading data"
                if let url = URL(string: "https://www.loading.com") {
                    homepageURL = url
                }
                description = "loading data"
                redactionReasons = .placeholder
                
            case .successfullyFetched(let detail):
                isOnTooManyRequestError = nil
                apply(detail: detail)
                
            case .tooManyRequest:
                isOnTooManyRequestError = true
                // user will see latest value
                if let detail = coins.value {
                    apply(detail: detail)
                }
                
            case .failure:
                isOnTooManyRequestError = false
                // user will see latest value
                if let detail = coins.value {
                    apply(detail: detail)
                }
            }
        }
        
        private func apply(detail: Coin) {
            redactionReasons = .invalidated
            let url = detail.links.homepage.first
            homepageURL = url
            if let url {
                let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
                homepageText = components?.host ?? ""
            }
           
            if let nsAttributedString = try? NSAttributedString(data: Data(detail.engDescription.utf8), options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil),
               var attributedString = try? AttributedString(nsAttributedString, including: \.uiKit) {
                attributedString.font = .system(size: 15, weight: .regular)
                description = attributedString
            } else {
                var attr = AttributedString(detail.engDescription)
                attr.font = .system(size: 15, weight: .regular)
                description = attr
            }
        }
    }
}

extension DetailView.ViewModel {
    enum State {
        case initial
        case loading
        case successfullyFetched(Coin)
        case tooManyRequest
        case failure
    }
}
