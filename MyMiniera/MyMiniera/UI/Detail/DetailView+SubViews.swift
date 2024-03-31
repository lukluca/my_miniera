//
//  DetailView+SubViews.swift
//  MyMiniera
//
//  Created by softwave on 31/03/24.
//

import SwiftUI

extension DetailView {
    struct Image: View {
        
        let url: URL
        
        var body: some View {
            HStack {
                Spacer()
                AsyncImage(url: url) { image in
                    image.resizable()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 100, height: 100)
                Spacer()
            }
        }
    }
}

extension DetailView {
    struct Error: View {
        
        let isTooManyRequest: Bool
        let action: () -> Void
        
        var body: some View {
            if isTooManyRequest {
                Button(action: action) {
                    Text("Too many request, please retry later!")
                        .foregroundColor(.red)
                }
            } else {
                Button(action: action) {
                    Text("Something went wrong, please retry!")
                        .foregroundColor(.red)
                }
            }
        }
    }
}

extension DetailView {
    struct Description: View {
    
        let description: AttributedString
        let redactionReasons: RedactionReasons
       
        
        var body: some View {
            Text(description)
                .redacted(reason: redactionReasons)
                .lineLimit(3)
        }
    }
}

extension DetailView {
    struct Homepage: View {
    
        let redactionReasons: RedactionReasons
        let linkText: String
        let linkURL: URL
        
        var body: some View {
            Link(linkText, destination: linkURL)
                .redacted(reason: redactionReasons)
        }
    }
}

extension DetailView {
    struct MarketData: View {
        
        let coin: CoinMarket
        
        var body: some View {
            VStack(alignment: .leading, spacing: 20) {
                
                VStack(alignment: .leading)  {
                    Text("Current price")
                        .fontWeight(.light)
                    
                    HStack {
                        
                        CurrentPrice(currentPrice: coin.currentPrice,
                                     isBull: coin.isBull)
                        
                        HStack(spacing: 0) {
                            Text(coin.priceChangePercentage24h, format: .percent)
                                .fontWeight(.ultraLight)
                            Text("*")
                                .fontWeight(.ultraLight)
                        }
                    }
                }
                
                VStack(alignment: .leading)  {
                    Text("Market cap")
                        .fontWeight(.light)
                    Text(coin.marketCap, format: .number)
                }
                
                VStack(alignment: .leading)  {
                    HStack(spacing: 0) {
                        Text("Last updated ")
                            .fontWeight(.ultraLight)
                        Text(coin.lastUpdated.formatted(.relative(presentation: .named, unitsStyle: .wide)))
                            .fontWeight(.light)
                        Text(" at ")
                            .fontWeight(.ultraLight)
                        Text(coin.lastUpdated.formatted())
                            .fontWeight(.light)
                    }
                    
                    HStack {
                        Text("* Percentage calculated with 24 h of tollerance")
                            .fontWeight(.ultraLight)
                            .fontWidth(.condensed)
                    }

                }
            }
        }
    }
}

// MARK: Preview

#Preview("Image") {
    DetailView.Image(url: .imagePreview)
}

#Preview("Error too many request") {
    DetailView.Error(isTooManyRequest: true, action: {})
}

#Preview("General error") {
    DetailView.Error(isTooManyRequest: false, action: {})
}

#Preview("Loading description") {
    DetailView.Description(description: AttributedString("loading"), redactionReasons: .placeholder)
}

#Preview("Description") {
    DetailView.Description(description: AttributedString(.bitcoinEngDesc), redactionReasons: .invalidated)
}

#Preview("Loading homepage") {
    DetailView.Homepage(redactionReasons: .placeholder, linkText: "loading", linkURL: .homepagePreview)
}

#Preview("Homepage") {
    DetailView.Homepage(redactionReasons: .invalidated, linkText: "www.home.com", linkURL: .homepagePreview)
}

#Preview("MarketData") {
    DetailView.MarketData(coin: .bitcoin)
}
