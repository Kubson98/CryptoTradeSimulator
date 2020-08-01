import UIKit

class PriceTableViewCell: UITableViewCell {
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var change24: UILabel!
    @IBOutlet weak var symbol: UILabel!
}

class PricesViewController: UITableViewController, CoinManagerDelegate {

    func didUpdateView(values: [CryptoCurrencyData]) {
        priceArray = values
    }

    let detailsVC = CryptoDetailsViewController()
    var coinManager = CoinManager()
    var priceArray: [CryptoCurrencyData] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        coinManager.delegate = self
        tableView.reloadData()
    }

    // MARK: - TABLEVIEW
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return priceArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "priceCell", for: indexPath) as! PriceTableViewCell
        let listPrices = priceArray[indexPath.row]

        let url = URL(string: "https://s2.coinmarketcap.com/static/img/coins/64x64/\(listPrices.id).png")!

        if let data = try? Data(contentsOf: url) {
            cell.logo.image = UIImage(data: data)
        }

        cell.name.text = String(listPrices.name)
        cell.symbol.text = String(listPrices.symbol)
        cell.price.text = String(format: "%.2f", listPrices.quote.USD.price)
        cell.price.text = ("\(cell.price.text!)$")
        cell.change24.text = String(format: "%.2f", listPrices.quote.USD.percent_change_24h)
        cell.change24.text = ("\(cell.change24.text!)%")
        changesColors(value: listPrices.quote.USD.percent_change_24h, change: cell.change24)

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToCharts", sender: self)

    }
    // MARK: - CHANGE COLORS CHANGE 24H PRICE
    func changesColors(value: Double, change: UILabel) {
        if value > 0 {
            change.textColor = UIColor(red: 0.00, green: 0.55, blue: 0.01, alpha: 1.00)
            change.text = ("+\(change.text!)")
        } else if value < 0 {
            change.textColor = UIColor(red: 0.72, green: 0.00, blue: 0.00, alpha: 1.00)
        } else {
            change.textColor = UIColor.gray
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! CryptoDetailsViewController

        if let indexPath = tableView.indexPathForSelectedRow {
            let cell = priceArray[indexPath.row]

            destinationVC.selectedCurrency = cell.name
            destinationVC.name = String(cell.name)
            destinationVC.change = String(format: "%.2f", cell.quote.USD.percent_change_24h)
            destinationVC.change = String("\(destinationVC.change!)%")
            destinationVC.price = String(format: "%.2f", cell.quote.USD.price)
            destinationVC.price = String("\(destinationVC.price!)$")
            destinationVC.symbol = cell.symbol

            let url = URL(string: "https://s2.coinmarketcap.com/static/img/coins/64x64/\(cell.id).png")!
            if let data = try? Data(contentsOf: url) {
                destinationVC.logo = UIImage(data: data)
            }
        }
    }
    // MARK: - REFRESH SWIPE
    @IBAction func refresh(_ sender: UIRefreshControl) {
        sender.endRefreshing()
        coinManager.getCoinPrice()
        tableView.reloadData()
    }

    // MARK: - VIEW WILL APPEAR
    override func viewWillAppear(_ animated: Bool) {
        coinManager.getCoinPrice()
        repeat {
            tableView.reloadData()
        } while priceArray.count == 0
    }
}
