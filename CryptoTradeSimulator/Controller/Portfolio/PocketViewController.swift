

import UIKit
import Coinpaprika
import FirebaseDatabase
import Firebase
import StoreKit

struct MyCustomError : Error {}


class PocketViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CoinManagerDelegate, SKPaymentTransactionObserver {
    @IBOutlet weak var accountBalance: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var accountLabel: UILabel!
    @IBOutlet weak var balanceView: UIView!
    
    let productID = "Kuba.CryptoTradeSimulator.ExtraMoney"
    var vcPrices = PricesViewController()
    var userId = Auth.auth().currentUser?.uid
    var coinManager = CoinManager()
    var pricesArray: [Data2] = []
    var nameCrypto: [String] = []
    var countCrypto: [Double] = []
    var valuesArray: [Double] = []
    var idsArray: [Int] = []
    var ref = DatabaseReference()
    var handle:DatabaseHandle?
    override func viewDidLoad() {
        super.viewDidLoad()
        balanceView.layer.cornerRadius = 10
        balanceView.layer.shadowColor = UIColor.systemGray2.cgColor
        balanceView.layer.shadowRadius = 4
        balanceView.layer.shadowOpacity = 0.5
        balanceView.layer.shadowOffset = CGSize(width: 0, height: 0)
        SKPaymentQueue.default().add(self)
        coinManager.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName:"PocketTableViewCell", bundle: nil), forCellReuseIdentifier: "pocketCell")
    }
    
    //MARK: - TABLEVIEW
    
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
        } else {
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
    
    //MARK: - CREATE PORTFOLIO
    
    func createPortfiolio() {
        ref = Database.database().reference()
        ref.child(userId!).childByAutoId().setValue([pricesArray[0].name: 10000.0])
        for x in 1..<pricesArray.count {
            var nameOfCoin = pricesArray[x].name
            let vowels: Set<Character> = [".", ",", "#", "@", "&", "%"]
            nameOfCoin.removeAll(where: { vowels.contains($0) })
            ref.child(userId!).childByAutoId().setValue([nameOfCoin: 0.0])
        }
    }
    
    //MARK: - BUY FUNCTION
    
    func buy(deal:DealModel, _ completion: @escaping (Result<String, Error>) -> Void) {
        ref = Database.database().reference()
        let keyDolars = ref.child(userId!).queryOrdered(byChild: "USD").queryStarting(atValue: 0).observe(.childAdded) { (snapshot) in
            let item = snapshot.value as? [String:Double]
            if ((item!["USD"]!) - deal.countDollars) < 0.0 {
                completion(.failure(MyCustomError()))
            } else {
                self.ref.child("\(self.userId!)/\(snapshot.key)").updateChildValues(["USD": (item!["USD"]!) - deal.countDollars])
                let key = self.ref.child(self.userId!).queryOrdered(byChild: "\(deal.nameCrypto)").queryStarting(atValue: 0).observe(.childAdded) { (snapshot) in
                    let item = snapshot.value as? [String:Double]
                    self.ref.child("\(self.userId!)/\(snapshot.key)").updateChildValues(["\(deal.nameCrypto)": (item!["\(deal.nameCrypto)"]!) + deal.countCrypto])
                    let money = String(deal.countCrypto)
                    let dollars = String(format: "%.2f", deal.countDollars)
                    completion(.success("Successfully BOUGHT \(money) \(deal.nameCrypto) for \(dollars)$!"))
                }
            }
        }
    }
    
    //MARK: - SELL FUNCTION
    
    func sell(deal:DealModel, _ completion: @escaping (Result<String, Error>) -> Void) {
        ref = Database.database().reference()
        let key = ref.child(userId!).queryOrdered(byChild: "\(deal.nameCrypto)").queryStarting(atValue: 0).observe(.childAdded) { (snapshot) in
            let item = snapshot.value as? [String:Double]
            if ((item!["\(deal.nameCrypto)"]!) - deal.countCrypto) < 0.0 {
                completion(.failure(MyCustomError()))
            } else {
                self.ref.child("\(self.userId!)/\(snapshot.key)").updateChildValues(["\(deal.nameCrypto)": (item!["\(deal.nameCrypto)"]!) - deal.countCrypto])
                let keyDolars = self.ref.child(self.userId!).queryOrdered(byChild: "USD").queryStarting(atValue: 0).observe(.childAdded) { (snapshot) in
                    let item = snapshot.value as? [String:Double]
                    self.ref.child("\(self.userId!)/\(snapshot.key)").updateChildValues(["USD": (item!["USD"]!) + deal.countDollars])
                    let money = String(deal.countCrypto)
                    let dollars = String(format: "%.2f", deal.countDollars)
                    completion(.success("Successfully SOLD \(money) \(deal.nameCrypto) for \(dollars)$!"))
                }
            }
        }
    }
    
    //MARK: - SHOW PORTFOLIO
    
    func showPortfolio() {
        ref = Database.database().reference()
        var x = 0
        handle = ref.child(userId!).observe(.childAdded, with: { (snapshot) in
            
            if let item = snapshot.value as? [String:Double] {
                for (key, value) in item {
                    self.nameCrypto.append(key)
                    self.countCrypto.append(value)
                    self.valuesArray.append(self.pricesArray[x].quote.USD.price * self.countCrypto[x])
                    var sum = self.valuesArray.reduce(0,+)
                    self.accountBalance.text = String(format: "%.2f",sum)
                    self.accountBalance.text = String("\(self.accountBalance.text!)$")
                    x = x + 1
                    
                    self.tableView.reloadData()
                }
            }
        }
        )
    }
    
    
    //MARK: - BUY MORE MONEY (APPLE PAY)
    
    @IBAction func buyMoney(_ sender: UIButton) {
        if SKPaymentQueue.canMakePayments() {
            let paymentRequest = SKMutablePayment()
            paymentRequest.productIdentifier = productID
            SKPaymentQueue.default().add(paymentRequest)
        }
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions{
            if transaction.transactionState == .purchased {
                print("Transaction Successful")
                SKPaymentQueue.default().finishTransaction(transaction)
                ref = Database.database().reference()
                let keyDolars = self.ref.child(self.userId!).queryOrdered(byChild: "USD").queryStarting(atValue: 0).observe(.childAdded) { (snapshot) in
                    let item = snapshot.value as? [String:Double]
                    self.ref.child("\(self.userId!)/\(snapshot.key)").updateChildValues(["USD": (item!["USD"]!) + 1000.0])
                }
            } else if transaction.transactionState == .failed {
                print("Transaction Failed")
                SKPaymentQueue.default().finishTransaction(transaction)
            }
        }
    }
    
    //MARK: - LOGOUT BUTTON PRESSED
    @IBAction func logoutButtonPressed(_ sender: UIButton) {
        do {
            try Auth.auth().signOut()
            userId = nil
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
        
    }
    
    //MARK: - Delegate Function
    
    func didUpdateView(values: [Data2]) {
        var copyArray = values
        let myArray = [0, 1, 1027, 825, 52, 1831, 3602, 2010, 2, 1839, 1975, 1765,  512, 1376, 3794, 1982, 109, 1896]
        copyArray.insert(Data2(name: "USD", id: -0, symbol: "$", quote: CryptoTradeSimulator.Quote(USD: CryptoTradeSimulator.Usd(price: 1.0, percent_change_1h: 0.0, percent_change_24h: 0.0))), at: 0)
        for y in 0..<myArray.count{
            for x in 0...60 {
                if copyArray[x].id == myArray[y] {
                    pricesArray.append(copyArray[x])
                }
            }
        }
    }
    
    //MARK: - VIEW WILL APPEAR
    override func viewWillAppear(_ animated: Bool) {
        
        coinManager.getCoinPrice()
        repeat {
            tableView.reloadData()
        } while pricesArray.count == 0
        ref = Database.database().reference()
        let key = ref.child(userId!).queryOrdered(byChild: "USD").queryStarting(atValue: 0).observe(.value) { (snapshot) in
            if snapshot.exists() == false {
                self.createPortfiolio()
            }
        }
        showPortfolio()
    }
    
    //MARK: - VIEW WILL DISAPPEAR
    override func viewWillDisappear(_ animated: Bool) {
        pricesArray.removeAll()
        valuesArray.removeAll()
        nameCrypto.removeAll()
        countCrypto.removeAll()
    }
}
