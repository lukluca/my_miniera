//
//  Coin.swift
//  MyMiniera
//
//  Created by lukluca on 28/03/24.
//

import Foundation

struct Coin: Decodable {
    let id: String
    let description: [String : String]
    let links: Links
}

extension Coin {
    struct Links {
        let homepage: [URL]
    }
}

extension Coin.Links: Decodable {
    
    enum CodingKeys: CodingKey {
        case homepage
    }
    
    init(from decoder: any Decoder) throws {
        let container: KeyedDecodingContainer<Coin.Links.CodingKeys> = try decoder.container(keyedBy: CodingKeys.self)
        let strings = try container.decode([String].self, forKey: .homepage)
        homepage = strings.compactMap { URL(string: $0) }
    }
}

extension Coin {
    var engDescription: String {
        description["en"] ?? ""
    }
}
