import UIKit
import Coinpaprika
import FirebaseDatabase
import Firebase
import StoreKit

class PocketViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CoinManagerDelegate {
    @IBOutlet weak var accountBalance: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var accountLabel: UILabel!
    @IBOutlet weak var balanceView: UIView!

    private var viewModel = PocketViewModel()
    private let productID = "Kuba.CryptoTradeSimulator.ExtraMoney"
    private var vcPrices = PricesViewController()
    private var userId = Auth.auth().currentUser?.uid
    private var coinManager = CoinManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        configureBalanceView(view: balanceView)
        SKPaymentQueue.default().add(self)
        coinManager.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "PocketTableViewCell", bundle: nil), forCellReuseIdentifier: "pocketCell")
    }

    private func configureBalanceView(view: UIView) {
        view.layer.cornerRadius = 10
        view.layer.shadowColor = UIColor.systemGray2.cgColor
        view.layer.shadowRadius = 4
        view.layer.shadowOpacity = 0.5
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
    }

    // MARK: - TABLEVIEW
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.nameCrypto.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "pocketCell", for: indexPath) as! PocketTableViewCell
        let listPrices = viewModel.pricesArray[indexPath.row]
        var url = URL(string: "https://s2.coinmarketcap.com/static/img/coins/64x64/\(listPrices.id).png")!
        if listPrices.id == 0 {
            url = URL(string: "https://www.iconpacks.net/icons/2/free-icon-dollar-coin-2139.png")!
            cell.numberLabel.text = String(format: "%.2f", viewModel.countCrypto[indexPath.row])
            cell.numberLabel.text = "\(cell.numberLabel.text!)\(listPrices.symbol)"
        } else {
            cell.numberLabel.text = "\(viewModel.countCrypto[indexPath.row])\(listPrices.symbol)"
        }
        if let data = try? Data(contentsOf: url) {
            cell.logo.image = UIImage(data: data)
        }
        cell.nameLabel.text = viewModel.nameCrypto[indexPath.row]
        cell.valueLabel.text = String(format: "%.2f", viewModel.countCrypto[indexPath.row] * listPrices.quote.USD.price)
        cell.valueLabel.text = "\(cell.valueLabel.text!)$"

        return cell
    }

    // MARK: - SHOW PORTFOLIO

    private func showPortfolio() {
        viewModel.drawPortfolio(tableView: tableView, accountLabel: accountBalance)
    }

    // MARK: - LOGOUT BUTTON PRESSED

    @IBAction func logoutButtonPressed(_ sender: UIButton) {
        viewModel.logoutUser()
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }

    // MARK: - Delegate Function

    func didUpdateView(values: [CryptoCurrencyData]) {
        viewModel.mutualCoins(values: values, destinationArray: &viewModel.pricesArray)
        viewModel.addDollar(destinationArray: &viewModel.pricesArray)
    }

    // MARK: - VIEW WILL APPEAR

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        coinManager.getCoinPrice()
        repeat {
            tableView.reloadData()
        } while viewModel.pricesArray.count == 0
        viewModel.databaseRef = Database.database().reference()
        let key = viewModel.databaseRef.child(userId!)
            .queryOrdered(byChild: "USD")
            .queryStarting(atValue: 0)
            .observe(.value) { (snapshot) in
                if snapshot.exists() == false {
                    self.viewModel.createPortfolio()
                }
        }
        showPortfolio()
    }

    // MARK: - VIEW WILL DISAPPEAR
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.pricesArray.removeAll()
        viewModel.valuesArray.removeAll()
        viewModel.nameCrypto.removeAll()
        viewModel.countCrypto.removeAll()
    }
}

// MARK: - BUY MORE MONEY (APPLE PAY)

extension PocketViewController: SKPaymentTransactionObserver {

    @IBAction func buyMoney(_ sender: UIButton) {
        if SKPaymentQueue.canMakePayments() {
            let paymentRequest = SKMutablePayment()
            paymentRequest.productIdentifier = productID
            SKPaymentQueue.default().add(paymentRequest)
        }
    }

    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            if transaction.transactionState == .purchased {
                print("Transaction Successful")
                SKPaymentQueue.default().finishTransaction(transaction)
                viewModel.paymentForMoney()
            } else if transaction.transactionState == .failed {
                print("Transaction Failed")
                SKPaymentQueue.default().finishTransaction(transaction)
            }
        }
    }

}
