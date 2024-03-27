//
//  Network+CoinGecko.swift
//  MyMiniera
//
//  Created by softwave on 27/03/24.
//

import Foundation
import Combine

extension Network {
    enum CoinGecko {
        case coinsList(includePlatform: Bool?)
    }
}

private extension Network.CoinGecko {
    var path: String {
        switch self {
        case .coinsList:
            "coins/list"
        }
    }
    
    var queryItems: [URLQueryItem] {
        switch self {
        case .coinsList(let includePlatform):
            guard let includePlatform else {
                return []
            }
            return [URLQueryItem(name: "include_platform", value: "\(includePlatform)")]
        }
    }
    
    var httpMethod: String {
        switch self {
        case .coinsList:
            "get"
        }
    }
    
    var validStatusCodes: (ClosedRange<Int>) {
        switch self {
        case .coinsList:
            (200...200)
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.coingecko.com"
        components.path = "/api/v3/" + path
        let queryItems = queryItems
        if !queryItems.isEmpty {
            components.queryItems = queryItems
        }
        guard let url = components.url else {
            throw Network.NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        request.addValue("application/json", forHTTPHeaderField: "accept")
       
        return request
    }
}

extension Network.CoinGecko {
    
    func fetch<T>() -> AnyPublisher<T, Error> where T : Decodable {
        
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
                .decode(type: T.self, decoder: JSONDecoder())
                .eraseToAnyPublisher()
        } catch {
            return Result<T, Error>.Publisher(error).eraseToAnyPublisher()
        }
    }
}
