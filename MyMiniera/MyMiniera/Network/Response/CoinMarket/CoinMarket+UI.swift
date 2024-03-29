//
//  CoinMarket+UI.swift
//  MyMiniera
//
//  Created by lukluca on 29/03/24.
//

import SwiftUI

extension CoinMarket {
    var color: Color {
        Color.from(text: symbol)
    }
    var isBull: Bool {
        priceChangePercentage24h > 0
    }
}

private extension Color {
    static func from(text: String) -> Color {
        var hash = 0
        let colorConstant = 131
        let maxSafeValue = Int.max / colorConstant
        for char in text.unicodeScalars{
            if hash > maxSafeValue {
                hash = hash / colorConstant
            }
            hash = Int(char.value) + ((hash << 5) - hash)
        }
        let finalHash = abs(hash) % (256*256*256);
        //let color = UIColor(hue:CGFloat(finalHash)/255.0 , saturation: 0.40, brightness: 0.75, alpha: 1.0)
        let color = Color(red: CGFloat((finalHash & 0xFF0000) >> 16) / 255.0, green: CGFloat((finalHash & 0xFF00) >> 8) / 255.0, blue: CGFloat((finalHash & 0xFF)) / 255.0, opacity: 0.5)
        return color
    }
}
