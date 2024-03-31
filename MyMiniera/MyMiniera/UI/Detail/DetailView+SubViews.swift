//
//  DetailView+SubViews.swift
//  MyMiniera
//
//  Created by lukluca on 31/03/24.
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
    struct Description: View {
        
        let description: AttributedString
        let redactionReasons: RedactionReasons
        
        var body: some View {
            LineLimitView(text: description,
                          limit: 3,
                          redactionReasons: redactionReasons)
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
                            Text(coin.percentageChange, format: .percent)
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
                            .font(.system(size: 10))
                        Text(coin.lastUpdated.formatted(.relative(presentation: .named, unitsStyle: .wide)))
                            .fontWeight(.light)
                            .font(.system(size: 10))
                        Text(" at ")
                            .fontWeight(.ultraLight)
                            .font(.system(size: 10))
                        Text(coin.lastUpdated.formatted())
                            .fontWeight(.light)
                            .font(.system(size: 10))
                    }
                    
                    HStack {
                        Text("* Percentage calculated with")
                            .fontWeight(.ultraLight)
                            .font(.system(size: 10))
                        Text("24 h")
                            .fontWeight(.light)
                            .font(.system(size: 10))
                        Text("of tollerance")
                            .fontWeight(.ultraLight)
                            .font(.system(size: 10))
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

#Preview("Loading description") {
    DetailView.Description(description: AttributedString("loading"), redactionReasons: .placeholder)
}

#Preview("Long Description") {
    DetailView.Description(description: AttributedString(.bitcoinEngDesc), redactionReasons: .invalidated)
}

#Preview("Short Description") {
    DetailView.Description(description: AttributedString("Soo short"), redactionReasons: .invalidated)
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

// MARK: LineLimitView
private struct LineLimitView: View {
    
    let text: AttributedString
    let limit: Int
    let redactionReasons: RedactionReasons
    
    @State private var isExpanded = false
    @State private var canBeExpanded = false
    
    var body: some View {
        VStack(spacing: 20) {
            Text(text)
                .redacted(reason: redactionReasons)
                .lineLimit(isExpanded ? nil : limit)
                .background {
                    ViewThatFits(in: .vertical) {
                        Text(text)
                            .redacted(reason: redactionReasons)
                            .hidden()
                        Color.clear
                            .onAppear {
                                canBeExpanded = true
                            }
                    }
                }
            
            if canBeExpanded {
                Button(action: {
                    withAnimation {
                        isExpanded.toggle()
                    }
                }, label: {
                    Text(isExpanded ? "Show less" : "Read more")
                        .fontWeight(.light)
                        .redacted(reason: redactionReasons)
                        .underline()
                })
            }
        }
    }
}
