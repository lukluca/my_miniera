//
//  CurrentPrice.swift
//  MyMiniera
//
//  Created by lukluca on 31/03/24.
//

import SwiftUI

struct CurrentPrice: View {
    
    let currentPrice: Double
    let isBull: Bool
    
    var body: some View {
        HStack {
            Text(currentPrice, format: .currency(code: "EUR"))
            BullInfo(viewModel: .init(isBull: isBull))
        }

    }
}

extension CurrentPrice {
    struct BullInfo: View {
        
        let viewModel: ViewModel
        
        var body: some View {
            Image(systemName: viewModel.imageSystemName)
                .frame(width: 20, height: 20)
                .foregroundColor(.white)
                .background(viewModel.color)
                .clipShape(Circle())
        }
    }
}

extension CurrentPrice.BullInfo {
    struct ViewModel {
        
        let imageSystemName: String
        let color: Color
        
        init(isBull: Bool) {
            imageSystemName = isBull ?  "arrow.up.right" : "arrow.down.right"
            color = isBull ? .green : .red
        }
    }
}

// MARK: Preview
#Preview("Bull") {
    CurrentPrice(currentPrice: 12345, isBull: true)
}

#Preview("Bear") {
    CurrentPrice(currentPrice: 12345, isBull: false)
}
