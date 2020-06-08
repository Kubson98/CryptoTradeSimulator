//
//  CoinData.swift
//  CryptoTradeSimulator
//
//  Created by Kuba on 26/05/2020.
//  Copyright © 2020 Kuba. All rights reserved.
//

import Foundation

struct CoinData: Codable {
    let data: [Data2]
    
}

struct Data2: Codable {
    let name: String
    let id: Int
    let symbol: String
    let quote: Quote
}

struct Quote: Codable {
    let USD: Usd
    }

struct Usd: Codable {
    let price: Double
    let percent_change_1h: Double
    let percent_change_24h: Double
}


