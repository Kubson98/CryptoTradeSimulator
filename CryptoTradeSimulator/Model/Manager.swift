import Foundation

protocol CoinManagerDelegate {
    func didUpdateView(values: [Data2])
}

struct CoinManager {
    var delegate: CoinManagerDelegate?
    let baseURL = "https://pro-api.coinmarketcap.com/v1/cryptocurrency/listings/latest?start=1&limit=60"

    // MARK: - URL ADRESS

    func getCoinPrice() {
        let urlString = "\(baseURL)&CMC_PRO_API_KEY=\(myApiKey)&convert=USD"
        self.performRequest(urlString: urlString)
    }

    // MARK: - URL REQUEST

    func performRequest(urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession.shared
            let task = session.dataTask(with: url) { (data, _, error) in
                if error != nil {
                    print(error!)
                    return
                }

                if let safeData = data {
                    let test = self.parseJSON(coinData: safeData)
                    self.delegate?.didUpdateView(values: test)
                }
            }
            task.resume()
        }
    }

    // MARK: - JSON CONNECT

    func parseJSON(coinData: Data) -> [Data2] {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(CoinData.self, from: coinData)
            let result = decodedData.data
            return result
        } catch {
            print(error)
            return error as! [Data2]
        }
    }
}
