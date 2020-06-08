//
//  ChartViewController.swift
//  CryptoTradeSimulator
//
//  Created by Kuba on 30/05/2020.
//  Copyright © 2020 Kuba. All rights reserved.
//

import UIKit
import Coinpaprika
import Charts
import TinyConstraints


class ChartViewController: UIViewController, ChartViewDelegate {
    

    lazy var lineChartView: LineChartView = {
        let chartView = LineChartView()
        chartView.backgroundColor = .systemBackground
        return chartView
    }()
    
    var selectedCurrency: String = ""

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(lineChartView)
        //setData()
        lineChartView.centerInSuperview()
        lineChartView.width(to: view)
        lineChartView.heightToWidth(of: view)
        lineChartView.rightAxis.enabled = false
        //lineChartView.
        lineChartView.xAxis.drawGridLinesEnabled = false
        lineChartView.xAxis.drawLabelsEnabled = false
        lineChartView.legend.enabled = false
        //self.lineChart.xAxis.avoidFirstLastClippingEnabled = true
        //lineChartView.xAxis = Date()
        
        setData()
        print("ok", yValues)
        
        
        // Do any additional setup after loading the view.
    }
    
    var yValues: [ChartDataEntry] = []
    
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        print(entry)
    }
    
    func setData(){
        
        let set1 = LineChartDataSet(entries: yValues, label: nil)
        set1.mode = .cubicBezier
        set1.drawCirclesEnabled = false
        set1.lineWidth = 3
        set1.setColor(.systemBlue)
        
        

    
        let data = LineChartData(dataSet: set1)
        lineChartView.data = data
    }
  
    
    func getID(nameCMC: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        Coinpaprika.API.coins().perform { (response) in
          switch response {
          case .success(let coins):
            for x in 0..<coins.count{
                if nameCMC == coins[x].name{
                    completion(.success(coins[x].id)) // i want return this value
                    
                }
            }
            case .failure(let error):
            print(error)
            // Failure reason as error
          }
        
        }
        
    }
    
    func test(id:String) {
          let monthsToAdd = 0
                 let daysToAdd = 0
                 let yearsToAdd = -3
                 let currentDate = Date()
          
                 var dateComponent = DateComponents()
                 
                 dateComponent.month = monthsToAdd
                 dateComponent.day = daysToAdd
                 dateComponent.year = yearsToAdd
                 
                
                
                 let futureDate = Calendar.current.date(byAdding: dateComponent, to: currentDate)
        Coinpaprika.API.tickerHistory(id: id , start: futureDate! , end: Date(), limit: 1000, quote: QuoteCurrency.usd, interval: API.TickerHistoryInterval.days7).perform { (response) in
          switch response {
            case .success(let tickerhistory):
             //  var arrayDate = [String]()
               //var arrayPrice = [Double]()
                for n in 0..<tickerhistory.count{
                    let x1 = tickerhistory[n].timestamp
                    /*let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "YYY-MM-DD HH:mm:ss"
                    let date = dateFormatter.string(from: x1)
                    dates.append(date)
                    
                    
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                    formatter.dateFormat = "dd-MMM-yyyy"
                    let date = formatter.string(from: x1)
                 */
                    
                    var priceDouble = Double(truncating: tickerhistory[n].price as NSNumber)
                    let timeInterval = x1.timeIntervalSince1970
                    var timeDouble = Double(timeInterval)
                    
                    
                    let tab: [ChartDataEntry] = [
                ChartDataEntry(x: timeDouble,
                               y: priceDouble)
                    ]
                    self.yValues.append(contentsOf: tab)
                    self.yValues.sort(by: { $0.x < $1.x })
                
                var myTime = Date(timeIntervalSince1970: timeDouble)
            }
               
               
                print("to jest to:\(self.yValues)")
                self.setData()
                
            
                
              // Failure reason as error
          case .failure(_):
              print(Error.self)
              }
          }
   
      }
    

    
    
    
    override func viewWillAppear(_ animated: Bool) {
        getID(nameCMC: selectedCurrency) { result in
            switch result {
            case .success(let id):
                print("ID is:", id)
                self.test(id: id)
                //self.setData()
                        
            case .failure(let error):
                print("Error is:", error)
            }
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

}
