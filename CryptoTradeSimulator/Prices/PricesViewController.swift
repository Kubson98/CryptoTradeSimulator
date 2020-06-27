//
//  PricesViewController.swift
//  CryptoTradeSimulator
//
//  Created by Kuba on 24/05/2020.
//  Copyright © 2020 Kuba. All rights reserved.
//

import UIKit

class PriceTableViewCell: UITableViewCell{
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var change24: UILabel!
    @IBOutlet weak var symbol: UILabel!
    
}
    
class PricesViewController: UITableViewController, CoinManagerDelegate {
    
    func didUpdateView(values: [Data2]) {
        priceArray = values
      //  tableView.reloadData()
      //  print(priceArray)
    }
    
    let detailsVC = CryptoDetailsViewController()

    
    
    var coinManager = CoinManager()
    
    @IBAction func refresh(_ sender: UIRefreshControl) {
        sender.endRefreshing()
        coinManager.getCoinPrice()
        tableView.reloadData()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        coinManager.delegate = self
        tableView.reloadData()
    }

    var priceArray: [Data2] = []
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return priceArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "priceCell", for: indexPath) as! PriceTableViewCell
         let listPrices = priceArray[indexPath.row]
        //cell.name.text = coinManager.
        //coinManager.
        let url = URL(string: "https://s2.coinmarketcap.com/static/img/coins/64x64/\(listPrices.id).png")!

           // Fetch Image Data
           if let data = try? Data(contentsOf: url) {
               // Create Image and Update Image View
            cell.logo.image = UIImage(data: data)
           }
           
        
        cell.name.text = String(listPrices.name)
        cell.symbol.text = String(listPrices.symbol)
        cell.price.text = String(format: "%.2f", listPrices.quote.USD.price)
        cell.price.text = ("\(cell.price.text!)$")
        cell.change24.text = String(format: "%.2f", listPrices.quote.USD.percent_change_24h)
        cell.change24.text = ("\(cell.change24.text!)%")
        
        changesColors(value: listPrices.quote.USD.percent_change_24h, change: cell.change24)
      
        //print(listPrices.name)
        return cell
        
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToCharts", sender: self)
        
    }
    
    func changesColors(value: Double, change: UILabel){
        if value > 0 {
         change.textColor = UIColor(red: 0.00, green: 0.55, blue: 0.01, alpha: 1.00)
         change.text = ("+\(change.text!)")
        }else if value < 0
        {
             change.textColor = UIColor(red: 0.72, green: 0.00, blue: 0.00, alpha: 1.00)
        }else {
         change.textColor = UIColor.gray
         }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     let destinationVC = segue.destination as! CryptoDetailsViewController
        
       if let indexPath = tableView.indexPathForSelectedRow {
        let cell = priceArray[indexPath.row]
        //print(cell.name)
        destinationVC.selectedCurrency = cell.name
        destinationVC.name = String(cell.name)
        destinationVC.change = String(format: "%.2f", cell.quote.USD.percent_change_24h)
        destinationVC.change = String("\(destinationVC.change!)%")
        destinationVC.price = String(format: "%.2f",cell.quote.USD.price)
        destinationVC.price = String("\(destinationVC.price!)$")

        destinationVC.symbol = cell.symbol
        
       
        let url = URL(string: "https://s2.coinmarketcap.com/static/img/coins/64x64/\(cell.id).png")!
        if let data = try? Data(contentsOf: url) {
            // Create Image and Update Image View
            destinationVC.logo = UIImage(data: data)
        }
        
        }
        
    }

    
    override func viewWillAppear(_ animated: Bool) {
        //repeat{
        
             coinManager.getCoinPrice()
        repeat{
                   tableView.reloadData()
        } while priceArray.count == 0
       
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
}

