//
//  Manager.swift
//  CryptoTradeSimulator
//
//  Created by Kuba on 25/05/2020.
//  Copyright © 2020 Kuba. All rights reserved.
//

import Foundation

protocol CoinManagerDelegate {
    func didUpdateView(values: [Data2])
    
}



struct CoinManager {
    
    var delegate: CoinManagerDelegate?
    //var delegate: CoinManagerDelegate?
    
    let baseURL = "https://pro-api.coinmarketcap.com/v1/cryptocurrency/listings/latest?start=1&limit=30"
    

    let apiKey = "5c3cd1f0-54f3-430f-8397-d425000b8843"
    

    
    func getCoinPrice(){
        //let urlString = "\(baseURL)/\(cryptoCurrency)/\(value)?apikey=\(apiKey)"
        
        let urlString = "\(baseURL)&CMC_PRO_API_KEY=\(apiKey)&convert=USD"
        self.performRequest(urlString: urlString)
       
      //  performRequest(urlString: urlString)
        
       // print(urlString)
    }
    func performRequest(urlString: String){
          // 1. Create URL
          if let url = URL(string: urlString){
              //2. Create URLSession
              let session = URLSession(configuration: .default)
              // 3. Give the session a Task
//              let task = session.dataTask(with: url) { (data, response, error) in
//                  if error != nil {
//                    print(error!)
//                    return
//                  }
            
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                  print(error!)
                  return
                }
                
                if let safeData = data {
                   let test = self.parseJSON(coinData: safeData)
                  self.delegate?.didUpdateView(values: test)
                //print(test)
                
                }
            }
                  
            task.resume()
   
      }
    }
    
    
    
    
    func parseJSON(coinData: Data) -> [Data2]{
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
