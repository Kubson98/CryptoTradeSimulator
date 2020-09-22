import Foundation

struct CoinData: Codable {
    let data: [CryptoCurrencyData]
}

struct CryptoCurrencyData: Codable {
    let name: String
    let id: Int
    let symbol: String
    let quote: Quote
}

struct Quote: Codable {
    let USD: Usd
}

struct Usd: Codable {
    let price: Double?
    let percent_change_1h: Double?
    let percent_change_24h: Double?
}
