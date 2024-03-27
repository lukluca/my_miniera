//
//  CoinsList.swift
//  MyMiniera
//
//  Created by lukluca on 27/03/24.
//

import Foundation

typealias Platforms = Dictionary<String, String>

struct CoinsList: Decodable {
    let id: String
    let symbol: String
    let name: String
    let platforms: Platforms?
}

