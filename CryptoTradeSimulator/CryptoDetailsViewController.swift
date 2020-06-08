//
//  CryptoDetailsViewController.swift
//  CryptoTradeSimulator
//
//  Created by Kuba on 08/06/2020.
//  Copyright © 2020 Kuba. All rights reserved.
//

import UIKit

class CryptoDetailsViewController: UIViewController {
    var selectedCurrency: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     let destinationVC = segue.destination as! ChartViewController
        
        destinationVC.selectedCurrency = selectedCurrency
        
    }

    /*    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
