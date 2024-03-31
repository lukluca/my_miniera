//
//  Error+UI.swift
//  MyMiniera
//
//  Created by lukluca on 31/03/24.
//

import Foundation

extension Error {
    var isTooManyRequest: Bool {
        switch self {
        case let networkError as Network.NetworkError:
            switch networkError {
            case .invalid(statusCode: let code) where code == 429:
                true
            default:
                false
            }
        default:
            false
        }
    }
}
