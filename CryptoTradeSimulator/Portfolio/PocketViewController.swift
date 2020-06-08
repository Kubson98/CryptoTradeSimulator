//
//  ViewController.swift
//  CryptoTradeSimulator
//
//  Created by Kuba on 24/05/2020.
//  Copyright © 2020 Kuba. All rights reserved.
//

import UIKit
import Coinpaprika

class PocketViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var accountBalance: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName:"PocketTableViewCell", bundle: nil), forCellReuseIdentifier: "pocketCell")
        
        
        // Do any additional setup after loading the view.
    }

        
    
    
    var cryptoCurrency = [
        Pocket(name:"Litecoin",value: 0,number: 0),
        Pocket(name:"Bitcoin",value: 0,number: 0),
        Pocket(name:"Etherium",value: 0,number: 0)
    ]
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cryptoCurrency.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "pocketCell", for: indexPath) as! PocketTableViewCell
         let listCurrency = cryptoCurrency[indexPath.row]
        cell.nameLabel.text = listCurrency.name
        cell.numberLabel.text = String(listCurrency.number)
        cell.valueLabel.text = String(listCurrency.value)
        
        return cell
        
    }


}

