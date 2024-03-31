//
//  Network.swift
//  MyMiniera
//
//  Created by lukluca on 27/03/24.
//

import Foundation
import Combine

enum Network {
    enum NetworkError: Error {
        case invalidURL
        case invalidResponse
        case invalid(statusCode: Int)
    }
}

protocol Fetchable {
    var validStatusCodes: (ClosedRange<Int>) { get }
    var decoder: JSONDecoder { get }
    
    func asURLRequest() throws -> URLRequest
}

extension Fetchable {
    
    func fetch<Item>() -> AnyPublisher<Item, Error> where Item : Decodable {
        
        do {
            let request = try asURLRequest()
            
            return URLSession.shared.dataTaskPublisher(for: request)
                .subscribe(on: DispatchQueue.global(qos: .background))
                .tryMap { data, response -> Data in
                    guard let httpResponse = response as? HTTPURLResponse else {
                        throw Network.NetworkError.invalidResponse
                    }
                    guard validStatusCodes.contains(httpResponse.statusCode) else {
                        throw Network.NetworkError.invalid(statusCode: httpResponse.statusCode)
                    }
                    return data
                }
                .decode(type: Item.self, decoder: decoder)
                .eraseToAnyPublisher()
        } catch {
            return Result<Item, Error>.Publisher(error).eraseToAnyPublisher()
        }
    }
}
