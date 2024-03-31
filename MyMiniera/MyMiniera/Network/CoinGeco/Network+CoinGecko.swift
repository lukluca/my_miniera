//
//  Network+CoinGecko.swift
//  MyMiniera
//
//  Created by lukluca on 27/03/24.
//

import Foundation
import Combine

extension Network {
    enum CoinGecko {
        case coins(id: String, parameters: CoinsParameters?)
        case coinsMarkets(parameters: CoinsMarketsParameters)
        case coinsMarketChart(id: String, parameters: CoinsMarketChartParameters)
    }
}

extension Network.CoinGecko: Fetchable {
    
    static let euro = "eur"
    
    var validStatusCodes: (ClosedRange<Int>) {
        switch self {
        case .coins, .coinsMarkets, .coinsMarketChart:
            (200...200)
        }
    }
    
    var decoder: JSONDecoder {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        return decoder
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

private extension Network.CoinGecko {
    var path: String {
        switch self {
        case .coins(let id, _):
            "coins/\(id)"
        case .coinsMarkets:
            "coins/markets"
        case .coinsMarketChart(let id, _):
            "coins/\(id)/market_chart"
        }
    }
    
    var queryItems: [URLQueryItem] {
        switch self {
        case .coins( _, let parameters):
            var items = [URLQueryItem]()
            
            if let localization = parameters?.localization {
                items.append(URLQueryItem(name: "localization", value: localization))
            }
            if let tickers = parameters?.tickers {
                items.append(URLQueryItem(name: "tickers", value: "\(tickers)"))
            }
            if let marketData = parameters?.marketData {
                items.append(URLQueryItem(name: "market_data", value: "\(marketData)"))
            }
            if let communityData = parameters?.communityData {
                items.append(URLQueryItem(name: "community_data", value: "\(communityData)"))
            }
            if let developerData = parameters?.developerData {
                items.append(URLQueryItem(name: "developer_data", value: "\(developerData)"))
            }
            if let sparkline = parameters?.sparkline {
                items.append(URLQueryItem(name: "sparkline", value: "\(sparkline)"))
            }
            return items
        case .coinsMarkets(let parameters):
            var items = [URLQueryItem]()
            
            items.append(URLQueryItem(name: "vs_currency", value: parameters.currency))
            
            if let order = parameters.order {
                items.append(URLQueryItem(name: "order", value: order.rawValue))
            }
            if let perPage = parameters.perPage {
                items.append(URLQueryItem(name: "per_page", value: "\(perPage)"))
            }
            if let page = parameters.page {
                items.append(URLQueryItem(name: "page", value: "\(page)"))
            }
            return items
        case .coinsMarketChart(_, let parameters):
            var items = [URLQueryItem]()
            
            items.append(URLQueryItem(name: "vs_currency", value: parameters.currency))
            items.append(URLQueryItem(name: "days", value: "\(parameters.days)"))
            
            if let interval = parameters.interval {
                items.append(URLQueryItem(name: "interval", value: interval.rawValue))
            }
            if let precision = parameters.precision {
                items.append(URLQueryItem(name: "precision", value: precision))
            }
            return items
        }
    }
    
    var httpMethod: String {
        switch self {
        case .coins, .coinsMarkets, .coinsMarketChart:
            "get"
        }
    }
}
