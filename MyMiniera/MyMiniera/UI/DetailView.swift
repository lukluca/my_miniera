//
//  DetailView.swift
//  MyMiniera
//
//  Created by lukluca on 29/03/24.
//

import SwiftUI

struct DetailView: View {
    
    let viewModel: ViewModel
    
    var body: some View {
        ScrollView {
            
            ZStack {
                VStack {
                    AsyncImage(url: viewModel.coin.image) { image in
                        image.resizable()
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: 100, height: 100)
                    
                    HStack {
                        CurrentPrice(currentPrice: viewModel.coin.currentPrice,
                                     isBull: viewModel.coin.isBull)
                        
                        HStack(spacing: 0) {
                            Text(viewModel.coin.priceChangePercentage24h, format: .percent)
                                .fontWeight(.ultraLight)
                            Text("*")
                                .fontWeight(.ultraLight)
                        }
                    }
                   
                    
                    HStack {
                        Text("Market cap:")
                            .fontWeight(.light)
                        Text(viewModel.coin.marketCap, format: .number)
                    }
                    
                    HStack(spacing: 0) {
                        Text("Last updated ")
                            .fontWeight(.ultraLight)
                        Text(viewModel.coin.lastUpdated.formatted(.relative(presentation: .named, unitsStyle: .wide)))
                            .fontWeight(.light)
                        Text(" at ")
                            .fontWeight(.ultraLight)
                        Text(viewModel.coin.lastUpdated.formatted())
                            .fontWeight(.light)
                        
                    }
                    
                    HStack {
                        Text("* Percentage calculated with 24 h of tollerance")
                            .fontWeight(.ultraLight)
                    }
                }
                .padding(15)
            }
            .background(
                RoundedRectangle(cornerRadius: 5)
                    .background(.clear)
                    .foregroundStyle(viewModel.coin.color)
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
        .navigationTitle(viewModel.coin.name)
    }
}

extension DetailView {
    struct ViewModel {
        let coin: CoinMarket
    }
}
