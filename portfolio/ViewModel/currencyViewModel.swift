//
//  currencyViewModel.swift
//  portfolio
//
//  Created by Tunay Toksöz on 27.02.2023.
//

import Foundation
import Charts
import UIKit

class currencyViewModel {
    
    private let networkService : NetworkServiceProtocol
    private let cdService : CoreDataServiceProtocol
    
    weak var output : currencyViewModelOutput?
    
    private var baseUrl = "https://api.freecurrencyapi.com/v1/"
    
    private var collectionArray : [collectionPortfolio] = []
    
    init(networkService: NetworkServiceProtocol, cdService: CoreDataServiceProtocol, output: currencyViewModelOutput? = nil) {
        self.networkService = networkService
        self.cdService = cdService
        self.output = output
    }
    
    private var currencyData : Currency?
    
    // MARK: - Currency Get
    func getCurrency() {
        if let url = URL(string: baseUrl + "latest?apikey=iMsPqn3Rhbamaq9BxTP0Wh6g7ENnwPd9Khxl1hSH&currencies=EUR%2CUSD%2CGBP%2CRUB%2CJPY%2CCAD%2CPHP%2CPLN&base_currency=TRY"){
            networkService.getData(url: url) { result in
                switch result{
                case .success(let data):
                    do {
                        let currency = try JSONDecoder().decode(Currency.self, from: data)
                        let keys : [String] = Array(currency.data.keys)
                        let values : [Double] = Array(currency.data.values)
                        let currencies = currency.data
                        
                        let groupKeys = self.grouppedKeys(array: keys)
                        let groupValues = self.grouppedValues(array: values)
                        
                        if keys.count % 4 == 0 && values.count % 4 == 0 {
                            self.output?.updateCurrencyLabels(keys: groupKeys, values: groupValues, currencies: currencies, isSucces: true)
                        } else {
                            self.output?.updateCurrencyLabels(keys: [], values: [], currencies: currencies, isSucces: false)
                        }
            
                    } catch {
                        self.output?.updateCurrencyLabels(keys: [], values: [], currencies: [:], isSucces: false)
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    func grouppedKeys(array : [String]) -> [[String]]{
        var groupedArray = [[String]]()
        for i in stride(from: 0, to: array.count, by: 4) {
            var group = [String]()
            for j in i..<(i + 4) {
                if j < array.count {
                    group.append(array[j])
                }
            }
            groupedArray.append(group)
        }
        return groupedArray
    }
    
    func grouppedValues(array : [Double]) -> [[Double]]{
        var groupedArray = [[Double]]()
        for i in stride(from: 0, to: array.count, by: 4) {
            var group = [Double]()
            for j in i..<(i + 4) {
                if j < array.count {
                    group.append(array[j])
                }
            }
            groupedArray.append(group)
        }
        return groupedArray
    }
    // MARK: - Currency * Portfolio
    func convertPortfolio(){
        
        var collectionArray : [collectionPortfolio] = [collectionPortfolio]()
        var total : Double = 0
        if let url = URL(string: baseUrl + "latest?apikey=iMsPqn3Rhbamaq9BxTP0Wh6g7ENnwPd9Khxl1hSH&currencies=EUR%2CUSD%2CGBP%2CRUB%2CJPY%2CCAD%2CPHP%2CPLN&base_currency=TRY"){
            networkService.getData(url: url) { result in
                switch result {
                case .success(let data):
                    do {
                        let currency = try JSONDecoder().decode(Currency.self, from: data)
                        self.cdService.getPortfolio { result in
                            switch result {
                            case .success(let portfolios):
                                for port in portfolios{
                                    collectionArray.append(collectionPortfolio(name: port.name, price: port.value, priceTL: port.value / (currency.data[port.name] ?? 1)))
                                }
                                collectionArray.removeAll { $0.price == 0.0 }
                                
                                for array in collectionArray {
                                    total += array.priceTL
                                }
                                UserDefaults.standard.set(total, forKey: "totalValue")
                                UserDefaults.standard.synchronize()
                                self.output?.fillPortfolio(collectionArray: collectionArray)
                                
                            case .failure(let error):
                                print(error.localizedDescription)
                            }
                        }
                    } catch {
                        self.output?.updateCurrencyLabels(keys: [[]], values: [[]], currencies: [:], isSucces: false)
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    
    
    
    
    // MARK: - ChartSet
    
    func updatePieChart(){
        
        var collectionArray : [collectionPortfolio] = [collectionPortfolio]()
     
        if let url = URL(string: baseUrl + "latest?apikey=iMsPqn3Rhbamaq9BxTP0Wh6g7ENnwPd9Khxl1hSH&currencies=EUR%2CUSD%2CGBP%2CRUB%2CJPY%2CCAD%2CPHP%2CPLN&base_currency=TRY"){
            networkService.getData(url: url) { result in
                switch result {
                case .success(let data):
                    do {
                        let currency = try JSONDecoder().decode(Currency.self, from: data)
                        self.cdService.getPortfolio { result in
                            switch result {
                            case .success(let portfolios):
                                for port in portfolios{
                                    collectionArray.append(collectionPortfolio(name: port.name, price: port.value, priceTL: port.value / (currency.data[port.name] ?? 1)))
                                }
                                
                                collectionArray.removeAll { $0.price == 0.0 }
                                self.calculatePercent(collectinArray: collectionArray)
                                
                            case .failure(let error):
                                print(error.localizedDescription)
                            }
                        }
                    } catch {
                        self.output?.updateCurrencyLabels(keys: [[]], values: [[]], currencies: [:], isSucces: false)
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    func calculatePercent(collectinArray : [collectionPortfolio] ) {
        var total = 0.0
        var percentArray : [String : Double] = [:]
        for array in collectinArray {
            total += array.priceTL
        }
        
        for array in collectinArray {
            percentArray[array.name] = array.priceTL * 100 / total
        }
        
        self.createPieChart(percentArray: percentArray)
        
    }
    
    
    func createPieChart(percentArray : [String : Double]){
        DispatchQueue.main.async {
            let view = UIView()
            let pieChartView = PieChartView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))

            var entryPortfolios = [ChartDataEntry]()
            
            for array in percentArray{
                let entry = PieChartDataEntry(value: array.value, label: array.key)
                entryPortfolios.append(entry)
            }
 
            let dataSet = PieChartDataSet(entries: entryPortfolios)
            dataSet.colors = ChartColorTemplates.colorful()
            
            let data = PieChartData(dataSet: dataSet)
            pieChartView.data = data
        
            let formatter = NumberFormatter()
            formatter.numberStyle = .percent
            formatter.maximumFractionDigits = 2
            formatter.multiplier = 1
            formatter.percentSymbol = "%"
                
            let setFormatter = DefaultValueFormatter(formatter: formatter)
            data.setValueFormatter(setFormatter)
            
            pieChartView.legend.enabled = true
            pieChartView.drawHoleEnabled = false
            pieChartView.isUserInteractionEnabled = false
            pieChartView.rotationAngle = 0
            pieChartView.drawEntryLabelsEnabled = false
            pieChartView.animate(xAxisDuration: 1.3, yAxisDuration: 1.3)
            pieChartView.frame = view.frame
            pieChartView.center = view.center
            pieChartView.backgroundColor = .white
            view.addSubview(pieChartView)
            self.output?.updateCharts(view: view, type: .pie)
        }
    }
    
    
    
}
