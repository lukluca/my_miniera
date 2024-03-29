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
        VStack(alignment: .leading) {
            Text(viewModel.coin.name)
                .fontWeight(.heavy)
            
            AsyncImage(url: viewModel.coin.image) { image in
                image.resizable()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 100, height: 100)
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
}

extension DetailView {
    struct ViewModel {
        let coin: CoinMarket
    }
}
