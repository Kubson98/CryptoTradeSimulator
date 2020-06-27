//
//  ViewController.swift
//  CryptoTradeSimulator
//
//  Created by Kuba on 24/05/2020.
//  Copyright © 2020 Kuba. All rights reserved.
//

import UIKit
import Coinpaprika
import FirebaseDatabase

struct MyCustomError : Error {}

class PocketViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CoinManagerDelegate {
    
    @IBOutlet weak var accountBalance: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var accountLabel: UILabel!
    
    func didUpdateView(values: [Data2]) {
        pricesArray = values
        pricesArray.insert(Data2(name: "USD", id: -0, symbol: "$", quote: CryptoTradeSimulator.Quote(USD: CryptoTradeSimulator.Usd(price: 1.0, percent_change_1h: 0.0, percent_change_24h: 0.0))), at: 0)
    }
    var vcPrices = PricesViewController()
    var vc = LoginViewController()
    var coinManager = CoinManager()
    var pricesArray: [Data2] = []
    var nameCrypto: [String] = []
    var countCrypto: [Double] = []
    var values: [Double] = []
    var ref = DatabaseReference()
    var handle:DatabaseHandle?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        coinManager.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName:"PocketTableViewCell", bundle: nil), forCellReuseIdentifier: "pocketCell")
        
    }
    
    var cryptoPocketArray: [String:Int] = [:]
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nameCrypto.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "pocketCell", for: indexPath) as! PocketTableViewCell
        let listPrices = pricesArray[indexPath.row]
        var url = URL(string: "https://s2.coinmarketcap.com/static/img/coins/64x64/\(listPrices.id).png")!
        if listPrices.id == 0 {
            url = URL(string: "https://www.iconpacks.net/icons/2/free-icon-dollar-coin-2139.png")!
            cell.numberLabel.text = String(format: "%.2f", countCrypto[indexPath.row])
            cell.numberLabel.text = "\(cell.numberLabel.text!)\(listPrices.symbol)"
        }else{
            cell.numberLabel.text = "\(countCrypto[indexPath.row])\(listPrices.symbol)"
        }
        if let data = try? Data(contentsOf: url) {
            cell.logo.image = UIImage(data: data)
        }
        cell.nameLabel.text = nameCrypto[indexPath.row]
        cell.valueLabel.text = String(format: "%.2f", countCrypto[indexPath.row] * listPrices.quote.USD.price)
        cell.valueLabel.text = "\(cell.valueLabel.text!)$"

        return cell
        
    }
    
    func createPortfiolio(){
        ref = Database.database().reference()
        ref.child(vc.name).childByAutoId().setValue([pricesArray[0].name: 10000.0])
        for x in 1..<15 {
            var nameOfCoin = pricesArray[x].name
            let vowels: Set<Character> = [".", ",", "#", "@", "&", "%"]
            nameOfCoin.removeAll(where: { vowels.contains($0) })
            ref.child(vc.name).childByAutoId().setValue([nameOfCoin: 0.0])
        }
    }
    
    func buy(deal:DealModel, _ completion: @escaping (Result<String, Error>) -> Void){
        ref = Database.database().reference()
        let keyDolars = ref.child(vc.name).queryOrdered(byChild: "USD").queryStarting(atValue: 0).observe(.childAdded) { (snapshot) in
            let item = snapshot.value as? [String:Double]
            if ((item!["USD"]!) - deal.countDollars) < 0.0 {
                completion(.failure(MyCustomError()))
            }else{
                
                self.ref.child("\(self.vc.name)/\(snapshot.key)").updateChildValues(["USD": (item!["USD"]!) - deal.countDollars])
                let key = self.ref.child(self.vc.name).queryOrdered(byChild: "\(deal.nameCrypto)").queryStarting(atValue: 0).observe(.childAdded) { (snapshot) in
                    let item = snapshot.value as? [String:Double]
                    self.ref.child("\(self.vc.name)/\(snapshot.key)").updateChildValues(["\(deal.nameCrypto)": (item!["\(deal.nameCrypto)"]!) + deal.countCrypto])
                    let money = String(deal.countCrypto)
                    let dollars = String(format: "%.2f", deal.countDollars)
                    completion(.success("Successfully BOUGHT \(money) \(deal.nameCrypto) for \(dollars)$!"))
                }
                
            }
        }
    }
    
    func sell(deal:DealModel, _ completion: @escaping (Result<String, Error>) -> Void){
        ref = Database.database().reference()
        let key = ref.child(vc.name).queryOrdered(byChild: "\(deal.nameCrypto)").queryStarting(atValue: 0).observe(.childAdded) { (snapshot) in
            let item = snapshot.value as? [String:Double]
            if ((item!["\(deal.nameCrypto)"]!) - deal.countCrypto) < 0.0 {
                completion(.failure(MyCustomError()))
            }else{
                self.ref.child("\(self.vc.name)/\(snapshot.key)").updateChildValues(["\(deal.nameCrypto)": (item!["\(deal.nameCrypto)"]!) - deal.countCrypto])
                let keyDolars = self.ref.child(self.vc.name).queryOrdered(byChild: "USD").queryStarting(atValue: 0).observe(.childAdded) { (snapshot) in
                    let item = snapshot.value as? [String:Double]
                    self.ref.child("\(self.vc.name)/\(snapshot.key)").updateChildValues(["USD": (item!["USD"]!) + deal.countDollars])
                    let money = String(deal.countCrypto)
                    let dollars = String(format: "%.2f", deal.countDollars)
                    completion(.success("Successfully SOLD \(money) \(deal.nameCrypto) for \(dollars)$!"))
                }
            }
        }
    }
    
    
    func showPortfolio(){
        ref = Database.database().reference()
        var x = 0
        handle = ref.child(vc.name).observe(.childAdded, with: { (snapshot) in

            if let item = snapshot.value as? [String:Double]{
                for (key, value) in item{
                    self.nameCrypto.append(key)
                    self.countCrypto.append(value)
                    self.values.append(self.pricesArray[x].quote.USD.price * self.countCrypto[x])
                    print(self.pricesArray[x].quote.USD.price)
                    var sum = self.values.reduce(0,+)
                    self.accountBalance.text = String(format: "%.2f",sum)
                    self.accountBalance.text = String("\(self.accountBalance.text!)$")
                    x = x + 1
                     
                    self.tableView.reloadData()
                    
                }
                
            }
        }
        )
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        coinManager.getCoinPrice()
        repeat{
            tableView.reloadData()
        } while pricesArray.count == 0
        values.removeAll()
        nameCrypto.removeAll()
        countCrypto.removeAll()
        showPortfolio()
        
    }
    
    //    var helloWorldTimer = Timer.scheduledTimer(timeInterval: 10.0, target: self, selector: Selector(("sayHello")), userInfo: nil, repeats: true)
    //
    //    func sayHello()
    //    {
    //        ref = Database.database().reference()
    //        let keyDolars = self.ref.child(self.vc.name).queryOrdered(byChild: "USD").queryStarting(atValue: 0).observe(.childAdded) { (snapshot) in
    //                 let item = snapshot.value as? [String:Double]
    //                 self.ref.child("\(self.vc.name)/\(snapshot.key)").updateChildValues(["USD": (item!["USD"]!) + 10])
    //    }
    //}
}

