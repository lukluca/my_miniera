//
//  MockModels.swift
//  MyMiniera
//
//  Created by lukluca on 31/03/24.
//

import Foundation

extension Array where Element == CoinMarket {
    static var preview: [Element] {
        [.bitcoin]
    }
}

extension CoinMarket {
    static var bitcoin: CoinMarket {
        CoinMarket(id: "bitcoin",
                   symbol: "btc",
                   name: "Bitcoin",
                   image: .imagePreview,
                   marketCap: 1392191776398,
                   currentPrice: 70774,
                   priceChangePercentage24h: 2.45097,
                   lastUpdated: Date())
    }
}

extension Coin {
    static var bitcoin: Coin {
        Coin(id: "bitcoin",
             description: ["en": .bitcoinEngDesc],
             links: Links(homepage: [.homepagePreview]))
    }
}

extension String {
    static var bitcoinEngDesc: String {
        "Bitcoin is the first successful internet money based on peer-to-peer technology; whereby no central bank or authority is involved in the transaction and production of the Bitcoin currency. It was created by an anonymous individual/group under the name, Satoshi Nakamoto. The source code is available publicly as an open source project, anybody can look at it and be part of the developmental process.\r\n\r\nBitcoin is changing the way we see money as we speak. The idea was to produce a means of exchange, independent of any central authority, that could be transferred electronically in a secure, verifiable and immutable way. It is a decentralized peer-to-peer internet currency making mobile payment easy, very low transaction fees, protects your identity, and it works anywhere all the time with no central authority and banks.\r\n\r\nBitcoin is designed to have only 21 million BTC ever created, thus making it a deflationary currency. Bitcoin uses the <a href=\"https://www.coingecko.com/en?hashing_algorithm=SHA-256\">SHA-256</a> hashing algorithm with an average transaction confirmation time of 10 minutes. Miners today are mining Bitcoin using ASIC chip dedicated to only mining Bitcoin, and the hash rate has shot up to peta hashes.\r\n\r\nBeing the first successful online cryptography currency, Bitcoin has inspired other alternative currencies such as <a href=\"https://www.coingecko.com/en/coins/litecoin\">Litecoin</a>, <a href=\"https://www.coingecko.com/en/coins/peercoin\">Peercoin</a>, <a href=\"https://www.coingecko.com/en/coins/primecoin\">Primecoin</a>, and so on.\r\n\r\nThe cryptocurrency then took off with the innovation of the turing-complete smart contract by <a href=\"https://www.coingecko.com/en/coins/ethereum\">Ethereum</a> which led to the development of other amazing projects such as <a href=\"https://www.coingecko.com/en/coins/eos\">EOS</a>, <a href=\"https://www.coingecko.com/en/coins/tron\">Tron</a>, and even crypto-collectibles such as <a href=\"https://www.coingecko.com/buzz/ethereum-still-king-dapps-cryptokitties-need-1-billion-on-eos\">CryptoKitties</a>."
    }
}

extension URL {
    static var imagePreview: URL {
        URL(string: "https://assets.coingecko.com/coins/images/1/large/bitcoin.png?1696501400")!
    }
    
    static var homepagePreview: URL {
        URL(string:  "http://www.bitcoin.org")!
    }
}

extension CoinMarketChart {
    static var preview: CoinMarketChart {
        CoinMarketChart(prices: [
            [
                1711411200000,
                64530.77647863455
            ],
            [
                1711497600000,
                64695.8250958296
            ],
            [
                1711584000000,
                64211.47397847694
            ],
            [
                1711670400000,
                65526.713768406174
            ],
            [
                1711756800000,
                64739.24207573283
            ],
            [
                1711843200000,
                64538.55260842681
            ],
            [
                1711923618000,
                65665.29519077268
            ]
        ])
    }
}
