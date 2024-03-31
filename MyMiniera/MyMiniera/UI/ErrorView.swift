//
//  ErrorView.swift
//  MyMiniera
//
//  Created by softwave on 31/03/24.
//

import SwiftUI

struct ErrorView: View {
    
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

#Preview("Error too many request") {
    ErrorView(isTooManyRequest: true, action: {})
}

#Preview("General error") {
    ErrorView(isTooManyRequest: false, action: {})
}
