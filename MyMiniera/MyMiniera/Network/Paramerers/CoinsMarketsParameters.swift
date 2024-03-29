//
//  CoinsMarketsParameters.swift
//  MyMiniera
//
//  Created by lukluca on 29/03/24.
//

import Foundation

struct CoinsMarketsParameters {
    let currency: String
    let order: Order?
    let perPage: Int?
    let page: Int?
}

extension CoinsMarketsParameters {
    enum Order: String {
        case marketCapAsc = "market_cap_asc"
        case marketCapDesc = "market_cap_desc"
        case volumeAsc = "volume_asc"
        case volumeDesc = "volume_desc"
        case idAsc = "id_asc"
        case idDesc = "id_desc"
    }
}
