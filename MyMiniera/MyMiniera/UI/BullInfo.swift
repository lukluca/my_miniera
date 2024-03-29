//
//  BullInfo.swift
//  MyMiniera
//
//  Created by lukluca on 29/03/24.
//

import SwiftUI

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

extension BullInfo {
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
    BullInfo(viewModel: .init(isBull: true))
}

#Preview("Bear") {
    BullInfo(viewModel: .init(isBull: false))
}
