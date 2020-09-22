import Foundation
import SCLAlertView

protocol CoinManagerDelegate: AnyObject {
    func didUpdateView(values: [CryptoCurrencyData])
}

class CoinManager {
    weak var delegate: CoinManagerDelegate?
    let baseURL = "https://pro-api.coinmarketcap.com/v1/cryptocurrency/listings/latest?start=1&limit=100"
    
    // MARK: - URL ADRESS
    func getCoinPrice() {
        let urlString = "\(baseURL)&CMC_PRO_API_KEY=\(myApiKey)&convert=USD"
        self.performRequest(urlString: urlString)
    }
    
    // MARK: - URL REQUEST
    private func performRequest(urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession.shared
            let task = session.dataTask(with: url) { [weak self] (data, response, error) in
                if error != nil {
                    SCLAlertView().showError("Error!", subTitle: "Something wrong with task.")
                    return
                }
                
                if let safeData = data {
                    let test = self?.parseJSON(coinData: safeData)
                    self?.delegate?.didUpdateView(values: test!)
                }
            }
            task.resume()
        }
    }
    
    // MARK: - JSON CONNECT
    private func parseJSON(coinData: Data) -> [CryptoCurrencyData] {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(CoinData.self, from: coinData)
            let result = decodedData.data
            return result
        } catch {
            SCLAlertView().showError("Error!", subTitle: "Something wrong with connect.")
            return error as! [CryptoCurrencyData]
        }
    }
}
