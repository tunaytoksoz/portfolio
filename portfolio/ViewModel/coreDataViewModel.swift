//
//  coreDataViewModel.swift
//  portfolio
//
//  Created by Tunay Toksöz on 28.02.2023.
//

import Foundation
import Charts
import UIKit

class coreDataViewModel {
    
    private let cdServiceProtocol : CoreDataServiceProtocol
    private let networkServiceProtocol : NetworkServiceProtocol

    weak var cdOutput : cdViewModelOutput?
    weak var currencyOutput : currencyViewModelOutput?
    
    private var baseUrl = "https://api.freecurrencyapi.com/v1/"
    
    init(cdServiceProtocol: CoreDataServiceProtocol, networkServiceProtocol: NetworkServiceProtocol, cdOutput: cdViewModelOutput? = nil, currencyOutput: currencyViewModelOutput? = nil) {
        self.cdServiceProtocol = cdServiceProtocol
        self.networkServiceProtocol = networkServiceProtocol
        self.cdOutput = cdOutput
        self.currencyOutput = currencyOutput
    }
    
    var retBool = false
    func saveObject(portfolio : portfolio, curr : Double) -> Bool{
        self.cdServiceProtocol.savePortfolio(portfolio: portfolio, curr: curr) { result in
            switch result {
            case .success(true):
                self.retBool = true
                    var total = UserDefaults.standard.object(forKey: "totalValue") as! Double
                    total += portfolio.value / curr
                    self.cdServiceProtocol.saveDailyTable(totalValue: total)
            case.failure(let error):
                print(error.localizedDescription)
                self.retBool = false
            default:
                self.retBool = false
            }
        }
        return retBool
    }
    
    func getPortfolio() {
        cdServiceProtocol.getPortfolio { result in
            switch result{
            case .success(let portfolio):
                print(portfolio)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func updateWeekChart(){
        var values : [DailyPortfolios] = [DailyPortfolios]()
        cdServiceProtocol.getDailyTable() { result in
            switch result{
            case .success(let data):
                values = data
                self.createBarChart(values: values)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func createBarChart(values : [DailyPortfolios]){
        
        DispatchQueue.main.async {
            let view = UIView()
            let chartView = BarChartView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
            var entries = [BarChartDataEntry]()
            
            var days : [String] = [String]()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM-dd"
            
            var arr : [Double] = [Double]()
            for (index, value) in values.enumerated() {
                let entry = BarChartDataEntry(x: Double(index), y: value.totalValue)
                entries.append(entry)
                days.append(dateFormatter.string(from: value.day!))
                arr.append(value.totalValue)
            }
  
            if arr.count > 0 {
                chartView.leftAxis.axisMaximum = arr.max()! * 1.5
            }
            
            chartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: days)
            chartView.xAxis.labelPosition = .bottom
            chartView.fitBars = true
            chartView.xAxis.granularity = 1.0
            chartView.xAxis.drawGridLinesEnabled = false
            
            chartView.leftAxis.axisMinimum = 0
            chartView.rightAxis.enabled = false
            
            let format = NumberFormatter()
            format.maximumFractionDigits = 2
            format.minimumFractionDigits = 0
            format.numberStyle = .decimal
            let formatter = DefaultValueFormatter(formatter: format)
            
            let dataSet = BarChartDataSet(entries: entries, label: "Last Week")
            let data = BarChartData(dataSet: dataSet)
            chartView.data = data
            chartView.data?.setValueFormatter(formatter)
            
            chartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
            chartView.frame = view.frame
            chartView.center = view.center
            chartView.backgroundColor = .white
            chartView.isUserInteractionEnabled = false
            
            view.addSubview(chartView)
            
            self.cdOutput?.updateCharts(view: view, type: .barDay)
        }
    }
    
    
    func updateWeekSummaryGraphic(){
        cdServiceProtocol.getWeeklyTable() { result in
            switch result {
            case .success(let success):
                self.calculateSummaryWeek(array: success)
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }
    
    
    func calculateSummaryWeek(array : [[DailyPortfolios]]){
        var weekArray : [DailyPortfolios] = [DailyPortfolios]()
        for subArray in array{
            var total = 0.0
            for i in subArray{
                total += i.totalValue
            }
            total = total / Double(array.count)
            weekArray.append(DailyPortfolios(totalValue: total, day: subArray.last?.day))
        }
        createWeekBarChart(values: weekArray)
    }
    
    
    func createWeekBarChart(values : [DailyPortfolios] ){
        DispatchQueue.main.async {
            let view = UIView()
            let chartView = BarChartView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
            var entries = [BarChartDataEntry]()
            
            for (index, value) in values.enumerated(){
                let entry = BarChartDataEntry(x: Double(index), y: value.totalValue)
                entries.append(entry)
            }
            
            chartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: ["Hafta 4", "Hafta 3", "Hafta 2", "Hafta 1"])
            chartView.xAxis.labelPosition = .bottom
            chartView.fitBars = true
            chartView.xAxis.granularity = 1.0
            chartView.xAxis.drawGridLinesEnabled = false
            
            chartView.leftAxis.axisMinimum = 0
            chartView.rightAxis.enabled = false
            
            let dataSet = BarChartDataSet(entries: entries, label: "Last 4 Week")
            let data = BarChartData(dataSet: dataSet)
            chartView.data = data
            
            chartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
            chartView.frame = view.frame
            chartView.center = view.center
            chartView.backgroundColor = .white
            chartView.isUserInteractionEnabled = false
            
            view.addSubview(chartView)
            
            self.cdOutput?.updateCharts(view: view, type: .barWeek)
            
            
        }
    }
    
    func updateMonthlyGraphic() {
        cdServiceProtocol.getMonthlyTable { result in
            switch result {
            case .success(let success):
                self.calculateMonthlyAverage(data: success)
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }
    
    func calculateMonthlyAverage(data : [String : [Double]]){
        var averages = [String : Double]()
        
        for (mont, values) in data {
            let total =  values.reduce(0, +)
            let count = values.count
            
            let avg = Double(total) / Double(count)
            averages[mont] = avg
        }
        createMonthlyBarChart(data: averages)
    }
    
    func createMonthlyBarChart(data : [String : Double]){
        DispatchQueue.main.async {
            let view = UIView()
            let chartView = BarChartView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
            var entries = [BarChartDataEntry]()
            var months = [String]()
            for (index, value) in data.enumerated(){
                let entry = BarChartDataEntry(x: Double(index), y: value.value)
                entries.append(entry)
                months.append(value.key)
            }
            
            chartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: months)
            chartView.xAxis.labelPosition = .bottom
            chartView.fitBars = true
            chartView.xAxis.granularity = 1.0
            chartView.xAxis.drawGridLinesEnabled = false
            
            chartView.leftAxis.axisMinimum = 0
            chartView.rightAxis.enabled = false
            
            let dataSet = BarChartDataSet(entries: entries, label: "Last \(months.count) months")
            let data = BarChartData(dataSet: dataSet)
            chartView.data = data
            
            chartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
            chartView.frame = view.frame
            chartView.center = view.center
            chartView.backgroundColor = .white
            chartView.isUserInteractionEnabled = false
            
            view.addSubview(chartView)
            
            self.cdOutput?.updateCharts(view: view, type: .barMonth)
        }
    }
}
