//
//  ErrorView.swift
//  MyMiniera
//
//  Created by lukluca on 31/03/24.
//

import SwiftUI

struct ErrorView: View {
    
    @Binding var state: ErrorView.State
    let action: () -> Void
    
    var body: some View {
        switch state {
        case .hidden:
            EmptyView()
        case .tooManyRequest:
            Button(action: action) {
                Text("Too many request, please retry later!")
                    .foregroundColor(.red)
            }
        case .generalFailure:
            Button(action: action) {
                Text("Something went wrong, please retry!")
                    .foregroundColor(.red)
            }
        }
    }
}

extension ErrorView {
    enum State {
        case hidden
        case tooManyRequest
        case generalFailure
    }
}

#Preview("Hidden") {
    ErrorView(state: .constant(.hidden), action: {})
}

#Preview("Error too many request") {
    ErrorView(state: .constant(.tooManyRequest), action: {})
}

#Preview("General failure") {
    ErrorView(state: .constant(.generalFailure), action: {})
}
