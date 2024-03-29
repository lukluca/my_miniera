//
//  Coin.swift
//  MyMiniera
//
//  Created by lukluca on 28/03/24.
//

import Foundation

struct Coin: Decodable {
    let id: String
    let symbol: String
    let name: String
    let image: Image
}


extension Coin {
    struct Image: Decodable {
        let thumb: String
        let small: String
        let large: String
    }
}
