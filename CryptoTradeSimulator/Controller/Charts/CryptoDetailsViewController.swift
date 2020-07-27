import UIKit

class CryptoDetailsViewController: UIViewController {
    
    @IBOutlet weak var logoCrypto: UIImageView!
    @IBOutlet weak var nameCrypto: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var changeLabel: UILabel!
    @IBOutlet weak var symbolLabel: UILabel!
    @IBOutlet weak var detailsView: UIView!
    
    var selectedCurrency: String = ""
    var selectedTime: Int = 1
    var logo: UIImage?
    var name: String?
    var price: String?
    var change: String?
    var symbol: String?
    var chartVC = ChartViewController()
    var pick = Int()
    
    var chartTime: [ChartModel] = [
        ChartModel(hours: -1, days: 0, months: 0, years: 0, interval: "5m"),
        ChartModel(hours: -24, days: 0, months: 0, years: 0, interval: "5m"),
        ChartModel(hours: 0, days: -7, months: 0, years: 0, interval: "30min"),
        ChartModel(hours: 0, days: 0, months: -1, years: 0, interval: "2h"),
        ChartModel(hours: 0, days: 0, months: 0, years: -1, interval: "1d")]
    
    var cryptoDetails: [Data2] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        detailsView.layer.cornerRadius = 10
        detailsView.clipsToBounds = true
        logoCrypto.image = logo
        nameCrypto.text = name
        priceLabel.text = price
        changeLabel.text = change
        symbolLabel.text = symbol
        
        if (change! as NSString).doubleValue > 0 {
            changeLabel.textColor = UIColor(red: 0.00, green: 0.55, blue: 0.01, alpha: 1.00)
            changeLabel.text = ("+\(changeLabel.text!)")
        } else if (change! as NSString).doubleValue < 0 {
            changeLabel.textColor = UIColor(red: 0.72, green: 0.00, blue: 0.00, alpha: 1.00)
        } else {
            changeLabel.textColor = UIColor.gray
        }
    }
    
    @IBAction func pickChange(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            chartVC.showChart(time: chartVC.chartTime[0])
        case 1:
            chartVC.showChart(time: chartVC.chartTime[1])
        case 2:
            chartVC.showChart(time: chartVC.chartTime[2])
        case 3:
            chartVC.showChart(time: chartVC.chartTime[3])
        case 4:
            chartVC.showChart(time: chartVC.chartTime[4])
        default:
            chartVC.showChart(time: chartVC.chartTime[1])
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ChartViewController
        chartVC = destinationVC
        destinationVC.selectedCurrency = selectedCurrency
        
    }
}
