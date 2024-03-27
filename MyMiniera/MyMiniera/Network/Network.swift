//
//  Network.swift
//  MyMiniera
//
//  Created by lukluca on 27/03/24.
//

import Foundation

enum Network {
    enum NetworkError: Error {
        case invalidURL
        case invalidResponse
        case invalid(statusCode: Int)
    }
}
