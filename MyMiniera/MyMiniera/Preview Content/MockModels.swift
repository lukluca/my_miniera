//
//  MockModels.swift
//  MyMiniera
//
//  Created by lukluca on 31/03/24.
//

import Foundation

extension Array where Element == CoinMarket {
    static var preview: [Element] {
        [.bitcoin, .ethereum]
    }
}

extension CoinMarket {
    static var bitcoin: CoinMarket {
        CoinMarket(id: "bitcoin",
                   symbol: "btc",
                   name: "Bitcoin",
                   image: .bitcoinImagePreview,
                   marketCap: 1392191776398,
                   currentPrice: 70774,
                   priceChangePercentage24h: 2.45097,
                   lastUpdated: Date())
    }
    
    static var ethereum: CoinMarket {
        CoinMarket(id: "ethereum",
                   symbol: "eth",
                   name: "Ethereum",
                   image: .ethereumImagePreview,
                   marketCap: 37571776398,
                   currentPrice: 3136.60,
                   priceChangePercentage24h: -1.47143,
                   lastUpdated: Date())
    }
}

extension Coin {
    static var bitcoin: Coin {
        Coin(id: "bitcoin",
             description: ["en": .bitcoinEngDesc],
             links: Links(homepage: [.bitcoinHomepagePreview]))
    }
    
    static var ethereum: Coin {
        Coin(id: "ethereum",
             description: ["en": .ethereumEngDesc],
             links: Links(homepage: [.ethereumHomepagePreview]))
    }
}

extension String {
    static var bitcoinEngDesc: String {
        "Bitcoin is the first successful internet money based on peer-to-peer technology; whereby no central bank or authority is involved in the transaction and production of the Bitcoin currency. It was created by an anonymous individual/group under the name, Satoshi Nakamoto. The source code is available publicly as an open source project, anybody can look at it and be part of the developmental process.\r\n\r\nBitcoin is changing the way we see money as we speak. The idea was to produce a means of exchange, independent of any central authority, that could be transferred electronically in a secure, verifiable and immutable way. It is a decentralized peer-to-peer internet currency making mobile payment easy, very low transaction fees, protects your identity, and it works anywhere all the time with no central authority and banks.\r\n\r\nBitcoin is designed to have only 21 million BTC ever created, thus making it a deflationary currency. Bitcoin uses the <a href=\"https://www.coingecko.com/en?hashing_algorithm=SHA-256\">SHA-256</a> hashing algorithm with an average transaction confirmation time of 10 minutes. Miners today are mining Bitcoin using ASIC chip dedicated to only mining Bitcoin, and the hash rate has shot up to peta hashes.\r\n\r\nBeing the first successful online cryptography currency, Bitcoin has inspired other alternative currencies such as <a href=\"https://www.coingecko.com/en/coins/litecoin\">Litecoin</a>, <a href=\"https://www.coingecko.com/en/coins/peercoin\">Peercoin</a>, <a href=\"https://www.coingecko.com/en/coins/primecoin\">Primecoin</a>, and so on.\r\n\r\nThe cryptocurrency then took off with the innovation of the turing-complete smart contract by <a href=\"https://www.coingecko.com/en/coins/ethereum\">Ethereum</a> which led to the development of other amazing projects such as <a href=\"https://www.coingecko.com/en/coins/eos\">EOS</a>, <a href=\"https://www.coingecko.com/en/coins/tron\">Tron</a>, and even crypto-collectibles such as <a href=\"https://www.coingecko.com/buzz/ethereum-still-king-dapps-cryptokitties-need-1-billion-on-eos\">CryptoKitties</a>."
    }
    
    static var ethereumEngDesc: String {
        "Ethereum is a global, open-source platform for decentralized applications. In other words, the vision is to create a world computer that anyone can build applications in a decentralized manner; while all states and data are distributed and publicly accessible. Ethereum supports smart contracts in which developers can write code in order to program digital value. Examples of decentralized apps (dapps) that are built on Ethereum includes tokens, non-fungible tokens, decentralized finance apps, lending protocol, decentralized exchanges, and much more.\r\n\r\nOn Ethereum, all transactions and smart contract executions require a small fee to be paid. This fee is called Gas. In technical terms, Gas refers to the unit of measure on the amount of computational effort required to execute an operation or a smart contract. The more complex the execution operation is, the more gas is required to fulfill that operation. Gas fees are paid entirely in Ether (ETH), which is the native coin of the blockchain. The price of gas can fluctuate from time to time depending on the network demand."
    }
}

extension URL {
    static var bitcoinImagePreview: URL {
        URL(string: "https://assets.coingecko.com/coins/images/1/large/bitcoin.png?1696501400")!
    }
    
    static var ethereumImagePreview: URL {
        URL(string: "https://assets.coingecko.com/coins/images/279/large/ethereum.png?1696501628")!
    }
    
    static var bitcoinHomepagePreview: URL {
        URL(string: "http://www.bitcoin.org")!
    }
    
    static var ethereumHomepagePreview: URL {
        URL(string: "https://ethereum.org")!
    }
}

private extension CoinMarketChart {
    static var bitcoinPreview: CoinMarketChart {
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
    
    static var ethereumPreview: CoinMarketChart {
        CoinMarketChart(prices: [
            [
                1711411200000,
                64695.8250958296
            ],
            [
                1711497600000,
                34695.8250958296
            ],
            [
                1711584000000,
                22211.47397847694
            ],
            [
                1711670400000,
                75526.713768406174
            ],
            [
                1711756800000,
                4739.24207573283
            ],
            [
                1711843200000,
                2224538.55260842681
            ],
            [
                1711923618000,
                785665.29519077268
            ]
        ])
    }
}

extension GraphView.Item {
    static var bitcoinPreview: GraphView.Item {
        CoinMarketChart.bitcoinPreview.priceChartItems(coinId: "bitcoin")
    }
    
    static var ethereumPreview: GraphView.Item {
        CoinMarketChart.ethereumPreview.priceChartItems(coinId: "ethereum")
    }
}
