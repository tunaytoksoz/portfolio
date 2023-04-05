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
    
    init(networkService: NetworkServiceProtocol, cdService: CoreDataServiceProtocol, calculate: CalculateProtocol, chartGenerator: ChartGeneratorProtocol, groupedData: GroupedDataProtocol) {
        self.networkService = networkService
        self.cdService = cdService
        self.calculate = calculate
        self.chartGenerator = chartGenerator
        self.groupedData = groupedData
    }

    func createURL() -> URL? {
        
        var component = URLComponents()
        component.scheme = FreeCurrencyApi.scheme.rawValue
        component.host = FreeCurrencyApi.host.rawValue
        component.path = FreeCurrencyApi.path.rawValue
        
        let queryApikey = URLQueryItem(name: FreeCurrencyApi.apikeyName.rawValue, value: FreeCurrencyApi.apikey.rawValue)
        let queryQuery = URLQueryItem(name: FreeCurrencyApi.queryName.rawValue, value: FreeCurrencyApi.query.rawValue)
        let queryBaseCurrency = URLQueryItem(name: FreeCurrencyApi.baseCurrencyName.rawValue, value: FreeCurrencyApi.baseCurrency.rawValue)
        
        component.queryItems = [queryApikey,queryQuery,queryBaseCurrency]
    
        return component.url
    }
    
    
    // MARK: - Currency Get
    func getCurrency() {
        if let url = createURL(){
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
                    print(error.localizedDescription)
                    self.output?.updateCurrencyLabels(keys: [], values: [], currencies: [:], isSucces: false)
                }
            }
        }
    }

    
    // MARK: - Currency * Portfolio
    func convertPortfolio(){
        
        var collectionArray : [collectionPortfolio] = [collectionPortfolio]()
        var total : Double = 0
        
        if let url = createURL(){
            networkService.getData(url: url) { result in
                switch result {
                case .success(let data):
                    do {
                        let currency = try JSONDecoder().decode(Currency.self, from: data)
                        self.cdService.getPortfolio { result in
                            switch result {
                            case .success(let portfolios):
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
        if let url = createURL(){
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
