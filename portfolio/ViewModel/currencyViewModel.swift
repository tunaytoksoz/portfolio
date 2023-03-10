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
    
    private var collectionArray : [collectionPortfolio] = []
    
    private var keys : [String] = [String]()
    private var values : [Double] = [Double]()
    
    init(networkService: NetworkServiceProtocol, cdService: CoreDataServiceProtocol, output: currencyViewModelOutput? = nil) {
        self.networkService = networkService
        self.cdService = cdService
        self.output = output
    }
    
    private var currencyData : Currency?
    
    let url2 = URL(string: "https://api.freecurrencyapi.com/v1/latest?apikey=iMsPqn3Rhbamaq9BxTP0Wh6g7ENnwPd9Khxl1hSH&currencies=&base_currency=TRY")
    let url = URL(string: "https://api.freecurrencyapi.com/v1/latest?apikey=iMsPqn3Rhbamaq9BxTP0Wh6g7ENnwPd9Khxl1hSH&currencies=EUR%2CUSD%2CGBP%2CRUB%2CJPY%2CCAD%2CPHP%2CPLN&base_currency=TRY")
    
    func getFullApi() {
        networkService.getData(url: url!) { result in
            switch result{
            case .success(let data):
                do {
                    let currency = try JSONDecoder().decode(Currency.self, from: data)
                    let keys : [String] = Array(currency.data.keys)
                    let values : [Double] = Array(currency.data.values)
                    self.output?.updateCurrencyLabels(keys: self.grouppedKeys(array: keys), values: self.grouppedValues(array: values), isSucces: true)
                } catch {
                    self.output?.updateCurrencyLabels(keys: [[]], values: [[]], isSucces: false)
                }
            case .failure(let error):
                print(error)
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
    
    func convertPortfolio(){
        var collectionArray : [collectionPortfolio] = [collectionPortfolio]()
        
        networkService.getData(url: url!) { result in
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
                            
                            self.output?.fillPortfolio(collectionArray: collectionArray)
                        case .failure(let error):
                            print(error.localizedDescription)
                        }
                    }
                } catch {
                    self.output?.updateCurrencyLabels(keys: [[]], values: [[]], isSucces: false)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // MARK: - ChartSet
    func updateChart(){
        
     var collectionArray : [collectionPortfolio] = [collectionPortfolio]()
     
     networkService.getData(url: url!) { result in
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
                 self.output?.updateCurrencyLabels(keys: [[]], values: [[]], isSucces: false)
             }
         case .failure(let error):
             print(error)
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
            
            pieChartView.frame = view.frame
            pieChartView.center = view.center
            view.addSubview(pieChartView)
            self.output?.updatePiechart(view: view)
        }
    }
}
