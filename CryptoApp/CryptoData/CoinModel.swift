//
//  CoinModel.swift
//  SwiftfulCrypto
//
//  Created by Nick Sarno on 5/8/21.
//

import Foundation

// CoinGecko API info
/*
 URL: https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=250&page=1&sparkline=true&price_change_percentage=24h
 
 JSON Response:
 {
     "id": "bitcoin",
     "symbol": "btc",
     "name": "Bitcoin",
     "image": "https://assets.coingecko.com/coins/images/1/large/bitcoin.png?1547033579",
     "current_price": 58908,
     "market_cap": 1100013258170,
     "market_cap_rank": 1,
     "fully_diluted_valuation": 1235028318246,
     "total_volume": 69075964521,
     "high_24h": 59504,
     "low_24h": 57672,
     "price_change_24h": 808.94,
     "price_change_percentage_24h": 1.39234,
     "market_cap_change_24h": 13240944103,
     "market_cap_change_percentage_24h": 1.21837,
     "circulating_supply": 18704250,
     "total_supply": 21000000,
     "max_supply": 21000000,
     "ath": 64805,
     "ath_change_percentage": -9.24909,
     "ath_date": "2021-04-14T11:54:46.763Z",
     "atl": 67.81,
     "atl_change_percentage": 86630.1867,
     "atl_date": "2013-07-06T00:00:00.000Z",
     "roi": null,
     "last_updated": "2021-05-09T04:06:09.766Z",
     "sparkline_in_7d": {
       "price": [
         57812.96915967891,
         57504.33531773738,
       ]
     },
     "price_change_percentage_24h_in_currency": 1.3923423473152687
   }
 
 */


import Foundation


struct CoinModel: Identifiable, Codable {
    let id, symbol, name: String
    let image: String
    let currentPrice: Double
    let marketCap, marketCapRank, fullyDilutedValuation: Double?
    let totalVolume, high24H, low24H: Double?
    let priceChange24H: Double?
    let priceChangePercentage24H: Double?
    let marketCapChange24H: Double?
    let marketCapChangePercentage24H: Double?
    let circulatingSupply, totalSupply, maxSupply, ath: Double?
    let athChangePercentage: Double?
    let athDate: String?
    let atl, atlChangePercentage: Double?
    let atlDate: String?
    let lastUpdated: String?
    let sparklineIn7D: SparklineIn7D?
    let priceChangePercentage24HInCurrency: Double?
    let currentHoldings: Double?
    
    
    enum CodingKeys: String, CodingKey {
        case id, symbol, name, image
        case currentPrice = "current_price"
        case marketCap = "market_cap"
        case marketCapRank = "market_cap_rank"
        case fullyDilutedValuation = "fully_diluted_valuation"
        case totalVolume = "total_volume"
        case high24H = "high_24h"
        case low24H = "low_24h"
        case priceChange24H = "price_change_24h"
        case priceChangePercentage24H = "price_change_percentage_24h"
        case marketCapChange24H = "market_cap_change_24h"
        case marketCapChangePercentage24H = "market_cap_change_percentage_24h"
        case circulatingSupply = "circulating_supply"
        case totalSupply = "total_supply"
        case maxSupply = "max_supply"
        case ath
        case athChangePercentage = "ath_change_percentage"
        case athDate = "ath_date"
        case atl
        case atlChangePercentage = "atl_change_percentage"
        case atlDate = "atl_date"
        case lastUpdated = "last_updated"
        case sparklineIn7D = "sparkline_in_7d"
        case priceChangePercentage24HInCurrency = "price_change_percentage_24h_in_currency"
        case currentHoldings
    }
    
    func updateHoldings(amount: Double) -> CoinModel {
        return CoinModel(id: id, symbol: symbol, name: name, image: image, currentPrice: currentPrice, marketCap: marketCap, marketCapRank: marketCapRank, fullyDilutedValuation: fullyDilutedValuation, totalVolume: totalVolume, high24H: high24H, low24H: low24H, priceChange24H: priceChange24H, priceChangePercentage24H: priceChangePercentage24H, marketCapChange24H: marketCapChange24H, marketCapChangePercentage24H: marketCapChangePercentage24H, circulatingSupply: circulatingSupply, totalSupply: totalSupply, maxSupply: maxSupply, ath: ath, athChangePercentage: athChangePercentage, athDate: athDate, atl: atl, atlChangePercentage: atlChangePercentage, atlDate: atlDate, lastUpdated: lastUpdated, sparklineIn7D: sparklineIn7D, priceChangePercentage24HInCurrency: priceChangePercentage24HInCurrency, currentHoldings: amount)
    }
    
    var currentHoldingsValue: Double {
        return (currentHoldings ?? 0) * currentPrice
    }
    
    var rank: Int {
        return Int(marketCapRank ?? 0)
    }
    
}


//class NetworkManager {
//    func fetchCoinData(completion: @escaping ([CoinModel]) -> Void) {
//        let ids = ["bitcoin", "ethereum", "binancecoin", "dogecoin"]
//        let urlString = "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&ids=\(ids.joined(separator: ","))&order=market_cap_desc&per_page=10&page=1&sparkline=false&price_change_percentage=24h"
//        guard let url = URL(string: urlString) else {
//            print("Invalid URL")
//            completion([])
//            return
//        }
//
//        URLSession.shared.dataTask(with: url) { data, response, error in
//            guard let data = data, error == nil else {
//                print("Network error: \(error?.localizedDescription ?? "Unknown error")")
//                completion([])
//                return
//            }
//
//            let decoder = JSONDecoder()
//            if let coins = try? decoder.decode([CoinModel].self, from: data) {
//                DispatchQueue.main.async {
//                    completion(coins)
//                }
//            } else {
//                print("Failed to decode JSON")
//                completion([])
//            }
//        }.resume()
//    }
//}
class NetworkManager {
    func fetchCoinData(completion: @escaping ([CoinModel]) -> Void) {
        // Check for cached data first
        if let cachedCoins = CacheManager.shared.getCachedCoins() {
            completion(cachedCoins)
            return
        }

        let ids =  [
            "bitcoin", "ethereum", "binancecoin", "dogecoin", "ripple",
              "litecoin", "cardano", "polkadot", "solana", "avalanche-2",
              "terra-luna", "chainlink", "matic-network", "stellar", "algorand",
              "tezos", "monero", "cosmos", "near", "filecoin",
              "aave", "uniswap", "tron", "eos", "iota",
              "decentraland", "vechain", "theta-token", "sushiswap", "compound",
              "klaytn", "zilliqa", "elrond-erd-2", "maker", "ftx-token",
              "crypto-com-chain", "waves", "dash", "chiliz", "hedera-hashgraph",
              "enjincoin", "holotoken", "nem", "digibyte", "qtum"
        ]
        let urlString = "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&ids=\(ids.joined(separator: ","))&order=market_cap_desc&per_page=10&page=1&sparkline=false&price_change_percentage=24h"
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            completion([])
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Network error: \(error?.localizedDescription ?? "Unknown error")")
                completion([])
                return
            }

            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 429 {
                print("Rate limit exceeded")
                completion([])
                return
            }

            let decoder = JSONDecoder()
            do {
                let coins = try decoder.decode([CoinModel].self, from: data)
                DispatchQueue.main.async {
                    CacheManager.shared.cacheCoins(coins) // Cache fetched coins
                    completion(coins)
                }
            } catch {
                print("Failed to decode JSON: \(error)")
                completion([])
            }
        }.resume()
    }
}



class CacheManager {
    static let shared = CacheManager()
    
    private let defaults = UserDefaults.standard
    private let cacheKey = "CachedCoinData"
    private let expiryInterval: TimeInterval = 300 // Cache expiry time in seconds

    func getCachedCoins() -> [CoinModel]? {
        if let data = defaults.data(forKey: cacheKey),
           let cache = try? JSONDecoder().decode(CoinCache.self, from: data),
           Date().timeIntervalSince(cache.timestamp) < expiryInterval {
            return cache.coins
        }
        return nil
    }

    func cacheCoins(_ coins: [CoinModel]) {
        let cache = CoinCache(coins: coins, timestamp: Date())
        if let data = try? JSONEncoder().encode(cache) {
            defaults.set(data, forKey: cacheKey)
        }
    }
}

struct CoinCache: Codable {
    let coins: [CoinModel]
    let timestamp: Date
}



struct SparklineIn7D: Codable {
    let price: [Double]?
}
