//
//  BuyViewController.swift
//  CryptoTradeSimulator
//
//  Created by Kuba on 19/06/2020.
//  Copyright © 2020 Kuba. All rights reserved.
//

import UIKit

//protocol paymentProtocol {
//    func buy(price:String)
//}



class BuyViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, CoinManagerDelegate, UITextFieldDelegate{
    @IBOutlet weak var countCoins: UITextField!
    @IBOutlet weak var sellButton: UIButton!
    @IBOutlet weak var nameCryptoCurr: UILabel!
    @IBOutlet weak var resultPrice: UITextField!
    @IBOutlet weak var buyButton: UIButton!
    func didUpdateView(values: [Data2]) {
                myLogos = values
    }
    
    @IBOutlet weak var logoPickerView: UIPickerView!
    var price = Double()
    var myLogos = [Data2]()
    var vc = CoinManager()
    var pocketVC = PocketViewController()
    //var delegate: paymentProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
          vc.delegate = self
        logoPickerView.delegate = self
        logoPickerView.dataSource = self
        resultPrice.delegate = self
        countCoins.delegate = self
        
        // Do any additional setup after loading the view.
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
       // print(vc.countCrypto.count)
        return 14
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
        
        //var rowString = String()
        let url = URL(string: "https://s2.coinmarketcap.com/static/img/coins/64x64/\(myLogos[row].id).png")!
         // Fetch Image Data
        if let data = try? Data(contentsOf: url) {
             // Create Image and Update Image View
            myImageView.image = UIImage(data: data)!
         }
        
        //let myLabel = UILabel(frame: CGRect(x: 60, y:0, width: pickerView.bounds.width - 90, height: 60 ))
        //myLabel.font = UIFont(name:some font, size: 18)
        //myLabel.text = rowString
        
        //myView.addSubview(myLabel)
        myView.addSubview(myImageView)
        
        return myView
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        nameCryptoCurr.text = myLogos[row].name
        price = myLogos[row].quote.USD.price
        if let count = Double(countCoins.text!) {
                          resultPrice.text = String(count*price)
          
                      }
    
    }
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        countCoins.endEditing(true)
        resultPrice.endEditing(true)
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
         if let count = Double(countCoins.text!) {
                   resultPrice.text = String(count*price)
                    buyButton.isHidden = false
                    sellButton.isHidden = false
               }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    @IBAction func buyButtonPressed(_ sender: UIButton) {
        let count = Double(countCoins.text!)
        let dolars = Double(resultPrice.text!)
        /*
        if pocketVC.buy(deal: DealModel(nameCrypto: nameCryptoCurr.text! , countCrypto: count!, countDollars: dolars!)) == "success"{
            
            print("to less of money bro")
            let alert = UIAlertController(title: "give more money from your mom ", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true)

        }else{
            print("success")
            let alert = UIAlertController(title: "success", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true)

        }*/
        pocketVC.buy(deal: DealModel(nameCrypto: nameCryptoCurr.text! , countCrypto: count!, countDollars: dolars!)) { result in
            switch result {
            case .success(let id):
                let alert = UIAlertController(title: id, message: "", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true)
                
            case .failure(let error):
                let alert = UIAlertController(title: "You don't have enough dollars to make this transaction", message: "", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true)
            }
        }
        
    }
    
    @IBAction func sellButtonPressed(_ sender: UIButton) {
        let count = Double(countCoins.text!)
        let dolars = Double(resultPrice.text!)
        pocketVC.sell(deal: DealModel(nameCrypto: nameCryptoCurr.text! , countCrypto: count!, countDollars: dolars!)) { result in
            switch result {
            case .success(let id):
                    let alert = UIAlertController(title: id, message: "", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(alert, animated: true)
                    
                case .failure(let error):
                    let alert = UIAlertController(title: "You don't have enough cryptocurrencies to make this transaction", message: "", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(alert, animated: true)
            }
            
        }
    }
    override func viewWillAppear(_ animated: Bool) {
       // vc.showPortfolio()
        vc.getCoinPrice()
        repeat{
            logoPickerView.reloadAllComponents()
               
        } while myLogos.count == 0
        logoPickerView.selectRow(0, inComponent: 0, animated: false)
        pickerView(logoPickerView, didSelectRow: 0, inComponent: 0)
        countCoins.text = ""
        resultPrice.text = ""
        buyButton.isHidden = true
        sellButton.isHidden = true
        
       
       // print("ok", myArray)
        //print(vc.countCrypto.count)
    }
}
