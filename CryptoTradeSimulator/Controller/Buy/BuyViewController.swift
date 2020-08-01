import UIKit
import SCLAlertView

class BuyViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, CoinManagerDelegate, UITextFieldDelegate {
    @IBOutlet weak var countCoins: UITextField!
    @IBOutlet weak var sellButton: UIButton!
    @IBOutlet weak var nameCryptoCurr: UILabel!
    @IBOutlet weak var resultPrice: UITextField!
    @IBOutlet weak var buyButton: UIButton!
    @IBOutlet weak var buyButtonView: UIView!
    @IBOutlet weak var sellButtonView: UIView!
    @IBOutlet weak var logoPickerView: UIPickerView!
    var price = Double()
    var myLogos = [CryptoCurrencyData]()
    var vc = CoinManager()
    var pocketVC = PocketViewController()
    var viewModel = PocketViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        vc.delegate = self
        logoPickerView.delegate = self
        logoPickerView.dataSource = self
        resultPrice.delegate = self
        countCoins.delegate = self
        buttonView(button: buyButtonView)
        buttonView(button: sellButtonView)
    }
    // MARK: - BUTTONVIEW CONFIGURE
    
    func buttonView(button: UIView) {
        button.layer.cornerRadius = 20
        button.layer.shadowColor = UIColor.systemGray2.cgColor
        button.layer.shadowRadius = 4
        button.layer.shadowOpacity = 0.5
        button.layer.shadowOffset = CGSize(width: 0, height: 0)
    }
    // MARK: - PICKERVIEW
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 17
    }

    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return 70
    }

    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 70
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return myLogos[row].name
    }

    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let myView = UIView(frame: CGRect(x: 0, y: 0, width: 65, height: 65))
        let myImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 65, height: 65))
        let url = URL(string: "https://s2.coinmarketcap.com/static/img/coins/64x64/\(myLogos[row].id).png")!

        if let data = try? Data(contentsOf: url) {
            myImageView.image = UIImage(data: data)!
        }
        myView.addSubview(myImageView)

        return myView
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        nameCryptoCurr.text = myLogos[row].name
        price = myLogos[row].quote.USD.price
        if let count = Double(countCoins.text!) {
            resultPrice.text = String(format: "%.2f", count*price)
        }
    }

    // MARK: - TEXFIELD
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        countCoins.endEditing(true)
        resultPrice.endEditing(true)
        return true
    }

    func textFieldDidChangeSelection(_ textField: UITextField) {
        if let count = Double(countCoins.text!) {
            resultPrice.text = String(format: "%.2f", count*price)
            buyButtonView.isHidden = false
            sellButtonView.isHidden = false
        }

        if countCoins.text == "" {
            resultPrice.text = ""
            buyButtonView.isHidden = true
            sellButtonView.isHidden = true
        }
    }

    // MARK: - BUY BUTTON PRESSED
    
    @IBAction func buyButtonPressed(_ sender: UIButton) {
        let count = Double(countCoins.text!)
        let dolars = Double(resultPrice.text!)
        viewModel.buyCoin(deal: DealModel(nameCrypto: nameCryptoCurr.text!, countCrypto: count!, countDollars: dolars!)) { result in
            switch result {
            case .success(let id):
                SCLAlertView().showSuccess("Successfully!", subTitle: id)

            case .failure(let error):
                SCLAlertView().showError("Unfortunately!", subTitle: "You don't have enough dollars to make this transaction")
            }
        }
    }

    // MARK: - SELL BUTTON PRESSED
    
    @IBAction func sellButtonPressed(_ sender: UIButton) {
        let count = Double(countCoins.text!)
        let dolars = Double(resultPrice.text!)
        viewModel.sellCoin(deal: DealModel(nameCrypto: nameCryptoCurr.text!, countCrypto: count!, countDollars: dolars!)) { result in
            switch result {
            case .success(let id):
                SCLAlertView().showSuccess("Successfully!", subTitle: id)

            case .failure(let error):
                SCLAlertView().showError("Unfortunately!", subTitle: "You don't have enough cryptocurrencies to make this transaction")
            }
        }
    }

    // MARK: - DELEGATE FUNCTION
    
    func didUpdateView(values: [CryptoCurrencyData]) {
        viewModel.mutualCoins(values: values, destinationArray: &myLogos)
    }

    // MARK: - VIEW WILL APPEAR
    
    override func viewWillAppear(_ animated: Bool) {
        vc.getCoinPrice()
        repeat {
            logoPickerView.reloadAllComponents()
        } while myLogos.count == 0
        logoPickerView.selectRow(0, inComponent: 0, animated: false)
        pickerView(logoPickerView, didSelectRow: 0, inComponent: 0)
        countCoins.text = ""
        resultPrice.text = ""
        buyButtonView.isHidden = true
        sellButtonView.isHidden = true
    }
}
