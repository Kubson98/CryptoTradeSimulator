//
//  coinPaprika.swift
//  CryptoTradeSimulator
//
//  Created by Kuba on 30/05/2020.
//  Copyright © 2020 Kuba. All rights reserved.
//

import Foundation
import Coinpaprika

Coinpaprika.API.global().perform { (response) in
  switch response {
  case .success(let stats): break
    // Successfully downloaded GlobalStats
    // stats.marketCapUsd - Market capitalization in USD
    // stats.volume24hUsd - Volume from last 24h in USD
    // stats.bitcoinDominancePercentage - Percentage share of Bitcoin MarketCap in Total MarketCap
    // stats.cryptocurrenciesNumber - Number of cryptocurrencies available on Coinpaprika
  case .failure(let error): break
    // Failure reason as error
  }
}
