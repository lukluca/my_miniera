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
            Text("Current price:")
                .fontWeight(.light)
            Text(currentPrice, format: .currency(code: "EUR"))
            BullInfo(viewModel: .init(isBull: isBull))
        }

    }
}
