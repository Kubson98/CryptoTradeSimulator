//
//  PocketViewModel.swift
//  CryptoTradeSimulator
//
//  Created by Kuba on 29/07/2020.
//  Copyright © 2020 Kuba. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase
import StoreKit

struct MyCustomError: Error {}

class PocketViewModel {
    var coinManager = CoinManager()
    var databaseRef = DatabaseReference()
    var databaseHandle: DatabaseHandle?
    var pricesArray: [CryptoCurrencyData] = []
    var userId = Auth.auth().currentUser?.uid
    var nameCrypto: [String] = []
    var countCrypto: [Double] = []
    var valuesArray: [Double] = []
    var idsArray: [Int] = []

    // MARK: - CREATE PORTFOLIO
    
    func createPortfolio() {
        databaseRef = Database.database().reference()
        databaseRef.child(userId!).childByAutoId().setValue([pricesArray[0].name: 10000.0])
        for cellNumber in 1..<pricesArray.count {
            var nameOfCoin = pricesArray[cellNumber].name
            let uniqueChars: Set<Character> = [".", ",", "#", "@", "&", "%"]
            nameOfCoin.removeAll(where: { uniqueChars.contains($0) })
            databaseRef.child(userId!).childByAutoId().setValue([nameOfCoin: 0.0])
        }
    }

    // MARK: - BUY FUNCTION
    
    func buyCoin(deal: DealModel, _ completion: @escaping (Result<String, Error>) -> Void) {
        databaseRef = Database.database().reference()
        let keyDolars = databaseRef.child(userId!)
            .queryOrdered(byChild: "USD")
            .queryStarting(atValue: 0)
            .observe(.childAdded) { (snapshot) in
                let item = snapshot.value as? [String: Double]
                if ((item!["USD"]!) - deal.countDollars) < 0.0 {
                    completion(.failure(MyCustomError()))
                } else {
                    self.databaseRef.child("\(self.userId!)/\(snapshot.key)")
                        .updateChildValues(["USD": (item!["USD"]!) - deal.countDollars])
                    let key = self.databaseRef.child(self.userId!)
                        .queryOrdered(byChild: "\(deal.nameCrypto)")
                        .queryStarting(atValue: 0)
                        .observe(.childAdded) { (snapshot) in
                            let item = snapshot.value as? [String: Double]
                            self.databaseRef.child("\(self.userId!)/\(snapshot.key)")
                                .updateChildValues(["\(deal.nameCrypto)": (item!["\(deal.nameCrypto)"]!) + deal.countCrypto])
                            let money = String(deal.countCrypto)
                            let dollars = String(format: "%.2f", deal.countDollars)
                            completion(.success("Successfully BOUGHT \(money) \(deal.nameCrypto) for \(dollars)$!"))
                    }
                }
        }
    }
    // MARK: - SELL FUNCTION
    
    func sellCoin(deal: DealModel, _ completion: @escaping (Result<String, Error>) -> Void) {
        databaseRef = Database.database().reference()
        let key = databaseRef.child(userId!)
            .queryOrdered(byChild: "\(deal.nameCrypto)")
            .queryStarting(atValue: 0)
            .observe(.childAdded) { (snapshot) in
                let item = snapshot.value as? [String: Double]
                if ((item!["\(deal.nameCrypto)"]!) - deal.countCrypto) < 0.0 {
                    completion(.failure(MyCustomError()))
                } else {
                    self.databaseRef.child("\(self.userId!)/\(snapshot.key)")
                        .updateChildValues(["\(deal.nameCrypto)": (item!["\(deal.nameCrypto)"]!) - deal.countCrypto])
                    let keyDolars = self.databaseRef.child(self.userId!)
                        .queryOrdered(byChild: "USD")
                        .queryStarting(atValue: 0)
                        .observe(.childAdded) { (snapshot) in
                            let item = snapshot.value as? [String: Double]
                            self.databaseRef.child("\(self.userId!)/\(snapshot.key)")
                                .updateChildValues(["USD": (item!["USD"]!) + deal.countDollars])
                            let money = String(deal.countCrypto)
                            let dollars = String(format: "%.2f", deal.countDollars)
                            completion(.success("Successfully SOLD \(money) \(deal.nameCrypto) for \(dollars)$!"))
                    }
                }
        }
    }

    // MARK: - LOGOUT FUNCTION
    
    func logoutUser() {
        do {
            try Auth.auth().signOut()
            userId = nil
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }

    // MARK: - Delegate Function
    
    func mutualCoins(values: [CryptoCurrencyData], destinationArray: inout [CryptoCurrencyData]) {
        for numberOfportfolioCurr in 0..<portfolioCurr.count {
            for numberOfCoinsRank in 0..<values.count {
                if values[numberOfCoinsRank].id == portfolioCurr[numberOfportfolioCurr] {
                    destinationArray.append(values[numberOfCoinsRank])
                }
            }
        }
    }

    // MARK: - ADD DOLLARS TO PORTFOLIO
    
    func addDollar(destinationArray: inout [CryptoCurrencyData]) {
        destinationArray.insert(CryptoCurrencyData(name: "USD",
                                      id: -0,
                                      symbol: "$",
                                      quote: CryptoTradeSimulator
                                        .Quote(USD: CryptoTradeSimulator.Usd(
                                            price: 1.0,
                                            percent_change_1h: 0.0,
                                            percent_change_24h: 0.0))),
                                at: 0)
    }

    // MARK: - DRAW PORTFOLIO
    
    func drawPortfolio(tableView: UITableView, accountLabel: UILabel) {
        databaseRef = Database.database().reference()
        var iterator = 0
        databaseHandle = databaseRef.child(userId!).observe(.childAdded, with: { (snapshot) in
            if let item = snapshot.value as? [String: Double] {
                for (key, value) in item {
                    self.nameCrypto.append(key)
                    self.countCrypto.append(value)
                    self.valuesArray.append(self.pricesArray[iterator].quote.USD.price * self.countCrypto[iterator])
                    let sum = self.valuesArray.reduce(0, +)
                    accountLabel.text = String(format: "%.2f", sum)
                    accountLabel.text = String("\(accountLabel.text!)$")
                    iterator += 1
                    tableView.reloadData()
                }
            }
        }
        )
    }

    // MARK: - PAYMENT FUNCTION (APPLE PAY)
    
    func paymentForMoney() {
        databaseRef = Database.database().reference()
        let keyDolars = self.databaseRef.child(self.userId!)
            .queryOrdered(byChild: "USD")
            .queryStarting(atValue: 0)
            .observe(.childAdded) { (snapshot) in
                let item = snapshot.value as? [String: Double]
                self.databaseRef.child("\(self.userId!)/\(snapshot.key)")
                    .updateChildValues(["USD": (item!["USD"]!) + 1000.0])
        }
    }
}
