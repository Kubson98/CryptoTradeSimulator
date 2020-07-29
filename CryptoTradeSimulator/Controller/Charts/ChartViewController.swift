import UIKit
import Coinpaprika
import Charts
import TinyConstraints

class ChartViewController: UIViewController, ChartViewDelegate {

    var selectedCurrency: String = ""
    var changeTime = -365
    var highlight: Highlight?
    lazy var lineChartView: LineChartView = {
        let chartView = LineChartView()
        chartView.backgroundColor = .systemBackground
        return chartView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(lineChartView)
        lineChartView.centerInSuperview()
        lineChartView.width(to: view)
        lineChartView.heightToWidth(of: view)
        lineChartView.rightAxis.enabled = false
        lineChartView.xAxis.drawGridLinesEnabled = false
        lineChartView.xAxis.drawAxisLineEnabled = false
        lineChartView.leftAxis.drawGridLinesEnabled = false
        lineChartView.leftAxis.drawAxisLineEnabled = false
        lineChartView.xAxis.drawLabelsEnabled = false
        lineChartView.legend.enabled = false
        lineChartView.doubleTapToZoomEnabled = false
        setData()
    }

    var yValues: [ChartDataEntry] = []

    func setData() {
        let set1 = LineChartDataSet(entries: yValues, label: nil)
        set1.mode = .cubicBezier
        set1.drawCirclesEnabled = false
        set1.lineWidth = 3
        set1.setColor(.systemBlue)
        set1.setDrawHighlightIndicators(false)
        let data = LineChartData(dataSet: set1)
        lineChartView.data = data
        data.setDrawValues(false)

    }

    func getID(nameCMC: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        Coinpaprika.API.coins().perform { (response) in
            switch response {
            case .success(let coins):
                for x in 0..<coins.count {
                    if nameCMC == coins[x].name {
                        completion(.success(coins[x].id))
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }

    func test(id: String, time: ChartModel) {

        var dateComponent = DateComponents()
        dateComponent.month = time.months
        dateComponent.day = time.days
        dateComponent.year = time.years
        dateComponent.hour = time.hours
        let currentDate = Date()
        let futureDate = Calendar.current.date(byAdding: dateComponent, to: currentDate)

        Coinpaprika
            .API
            .tickerHistory(id: id,
                           start: futureDate!,
                           end: Date(),
                           limit: 1000,
                           quote: QuoteCurrency.usd,
                           interval: API
                                    .TickerHistoryInterval(rawValue: time.interval)!)
                                    .perform { (response) in
            switch response {
            case .success(let tickerhistory):
                for n in 0..<tickerhistory.count {
                    let x1 = tickerhistory[n].timestamp
                    let priceDouble = Double(truncating: tickerhistory[n].price as NSNumber)
                    let timeInterval = x1.timeIntervalSince1970
                    let timeDouble = Double(timeInterval)
                    let tab: [ChartDataEntry] = [
                        ChartDataEntry(x: timeDouble,
                                       y: priceDouble)]
                    self.yValues.append(contentsOf: tab)
                    self.yValues.sort(by: { $0.x < $1.x })
                }
                self.setData()

            case .failure:
                print(Error.self)
            }
        }

    }
    var chartTime: [ChartModel] = [
        ChartModel(hours: -1, days: 0, months: 0, years: 0, interval: "5m"),
        ChartModel(hours: -24, days: 0, months: 0, years: 0, interval: "5m"),
        ChartModel(hours: 0, days: -7, months: 0, years: 0, interval: "30m"),
        ChartModel(hours: 0, days: 0, months: -1, years: 0, interval: "2h"),
        ChartModel(hours: 0, days: 0, months: 0, years: -1, interval: "1d")]

    func showChart(time: ChartModel) {
        getID(nameCMC: selectedCurrency) { result in
            switch result {
            case .success(let id):
                self.yValues.removeAll()
                self.test(id: id, time: time)

            case .failure(let error):
                print("Error is:", error)
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        showChart(time: chartTime[1])
    }
}
