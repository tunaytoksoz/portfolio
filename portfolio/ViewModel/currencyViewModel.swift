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
    private let calculate : CalculateProtocol
    private let chartGenerator : ChartGeneratorProtocol
    private let groupedData : GroupedDataProtocol
    
    weak var output : currencyViewModelOutput?
    
    private var baseUrl = "https://api.freecurrencyapi.com/v1/"
    
    init(networkService: NetworkServiceProtocol, cdService: CoreDataServiceProtocol, calculate: CalculateProtocol, chartGenerator: ChartGeneratorProtocol, groupedData: GroupedDataProtocol, output: currencyViewModelOutput? = nil) {
        self.networkService = networkService
        self.cdService = cdService
        self.calculate = calculate
        self.chartGenerator = chartGenerator
        self.groupedData = groupedData
        self.output = output
    }
    
    // MARK: - Currency Get
    func getCurrency() {
        if let url = URL(string: baseUrl + "latest?apikey=iMsPqn3Rhbamaq9BxTP0Wh6g7ENnwPd9Khxl1hSH&currencies=EUR%2CUSD%2CGBP%2CRUB%2CJPY%2CCAD%2CPHP%2CPLN&base_currency=TRY"){
            networkService.getData(url: url) { result in
                
                switch result{
                case .success(let data):
                    do {
                        let currency = try JSONDecoder().decode(Currency.self, from: data)
                        
                        let groupKeys = self.groupedData.groupedKeys(array: Array(currency.data.keys))
                        let groupValues = self.groupedData.groupedValues(array: Array(currency.data.values))
                        
                        if Array(currency.data.keys).count % 4 == 0 && Array(currency.data.values).count % 4 == 0 {
                            self.output?.updateCurrencyLabels(keys: groupKeys, values: groupValues, currencies: currency.data, isSucces: true)
                        } else {
                            self.output?.updateCurrencyLabels(keys: [], values: [], currencies: currency.data, isSucces: false)
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
                                print(currency)
                                collectionArray = self.calculate.calculateTL(portfolios: portfolios, currency: currency)
                                
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
     
        if let url = URL(string: baseUrl + "latest?apikey=iMsPqn3Rhbamaq9BxTP0Wh6g7ENnwPd9Khxl1hSH&currencies=EUR%2CUSD%2CGBP%2CRUB%2CJPY%2CCAD%2CPHP%2CPLN&base_currency=TRY"){
            networkService.getData(url: url) { result in
                switch result {
                case .success(let data):
                    do {
                        let currency = try JSONDecoder().decode(Currency.self, from: data)
                        self.cdService.getPortfolio { result in
                            switch result {
                            case .success(let portfolios):
                                let collectionArray = self.calculate.calculateTL(portfolios: portfolios, currency: currency)
                                let percentArray = self.calculate.calculatePercent(collectinArray: collectionArray)
                                self.chartGenerator.createPieChart(percentArray: percentArray, output: self.output!)
                                
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
}
