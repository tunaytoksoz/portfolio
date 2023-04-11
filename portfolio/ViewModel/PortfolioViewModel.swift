//
//  PortfolioViewModel.swift
//  portfolio
//
//  Created by Tunay Toksöz on 8.04.2023.
//

import Foundation

class PortfolioViewModel {
    
    private let coreDataService : CoreDataServiceProtocol
    private let networkService : NetworkServiceProtocol
    private let chartGenerator : ChartGeneratorProtocol
    private let groupedData : GroupedDataProtocol
    private let calculate : CalculateProtocol
    
    weak var delegate : PortfolioViewControllerDelegate?
    
    init(coreDataService: CoreDataServiceProtocol, networkService: NetworkServiceProtocol,
         chartGenerator: ChartGeneratorProtocol, groupedData: GroupedDataProtocol,
         calculate: CalculateProtocol) {
        self.coreDataService = coreDataService
        self.networkService = networkService
        self.chartGenerator = chartGenerator
        self.groupedData = groupedData
        self.calculate = calculate
    }
    
    private var retBool = false
    
    func createURL() -> URL? {
        let apikey = URLQueryItem(name: "apikey", value: "iMsPqn3Rhbamaq9BxTP0Wh6g7ENnwPd9Khxl1hSH")
        let  currenciesQuery =  URLQueryItem(name: "currencies", value: "EUR,USD,GBP,RUB,JPY,CAD,PHP,PLN")
        let baseCurrencyQuery = URLQueryItem(name: "base_currency", value: "TRY")
        
        let url = NetworkComponent(scheme: "https", host: "api.freecurrencyapi.com", path: "/v1/latest", queryItems: [apikey, currenciesQuery, baseCurrencyQuery]).url
        
        return url
    }
    
    func getCurrency() {
        if let url = createURL(){
            networkService.getData(url: url, expecting: Currency.self) { result in
                switch result {
                case .success(let currencies):
                    if currencies.data.count % 4 == 0 && currencies.data.count > 0 {
                        var keys : [[String]] = self.groupedData.groupedKeys(array: Array(currencies.data.keys))
                        var values : [[Double]] = self.groupedData.groupedValues(array: Array(currencies.data.values))
                        
                        self.delegate?.updateCurrencyLabels(keys: keys, values: values, currencies: currencies, isSucces: true)
                    } else {
                        self.delegate?.updateCurrencyLabels(keys: [[]], values: [[]], currencies: Currency(data: [:]), isSucces: false)
                    }
                case .failure(let failure):
                    print(failure.localizedDescription)
                    self.delegate?.updateCurrencyLabels(keys: [[]], values: [[]], currencies: Currency(data: [:]), isSucces: false)
                }
            }
        }
    }
    
    
    func fillPortfolio(currencies : [String : Double]) {
        var collectionArray : [collectionPortfolio] = [collectionPortfolio]()
        var total : Double = 0
        
        coreDataService.getPortfolio { result in
            switch result {
            case .success(let portfolio):
                collectionArray = self.calculate.calculateTL(portfolios: portfolio, currency: currencies)
                
                for array in collectionArray {
                    total += array.priceTL
                }
                UserDefaults.standard.set(total, forKey: "totalValue")
                UserDefaults.standard.synchronize()
                
                self.delegate?.fillPortfolio(collectionArray: collectionArray, isSucces: true)
            case .failure(let failure):
                print(failure)
                self.delegate?.fillPortfolio(collectionArray: [collectionPortfolio](), isSucces: false)
            }
        }
    }
    
    func saveTransaction(portfolio : Portfolios, curr : Double) -> Bool{
        self.coreDataService.savePortfolio(portfolio: portfolio, curr: curr) { result in
            switch result {
            case .success(true):
                self.retBool = true
                    var total = UserDefaults.standard.object(forKey: "totalValue") as! Double
                    total += portfolio.value / curr
                    self.coreDataService.saveDailyTable(totalValue: total)
            case .failure(let error):
                print(error.localizedDescription)
                self.retBool = false
            default:
                self.retBool = false
            }
        }
        return retBool
    }
    
    func createPieChart(collectionArray : [collectionPortfolio]){
        
        let percentArray = self.calculate.calculatePercent(collectinArray: collectionArray)
        
        let view = chartGenerator.createPieChart(percentArray: percentArray)
        
        self.delegate?.updateCharts(view: view, type: .pie)
    }
    
    func updateLastWeekChart(){
        
        var values : [DailyPortfolios] = [DailyPortfolios]()
        coreDataService.getLastWeekTable() { result in
            switch result{
            case .success(let data):
                values = data
                let view = self.chartGenerator.createDailyBarChart(values: values)
                self.delegate?.updateCharts(view: view, type: .barDay)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func updateWeeklySummaryChart(){
        coreDataService.getWeeklyTable() { result in
            switch result {
            case .success(let success):
                let value = self.calculate.calculateAverageWeek(array: success)
                let view = self.chartGenerator.createWeeklyBarChart(values: value)
                self.delegate?.updateCharts(view: view, type: .barWeek)
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }
    
    func updateMonthlyChart() {
        coreDataService.getMonthlyTable { result in
            switch result {
            case .success(let success):
                let value = self.calculate.calculateMonthlyAverage(data: success)
                let view = self.chartGenerator.createMonthlyBarChart(data: value)
                self.delegate?.updateCharts(view: view, type: .barMonth)
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }
    
    func updateTransactionTable(){
        coreDataService.getTransactions { result in
            switch result {
            case .success(let portfolio):
                self.delegate?.updateTransactionsTable(porfolio: portfolio, isSucces: true)
            case .failure(let error):
                print(error.localizedDescription)
                self.delegate?.updateTransactionsTable(porfolio: [], isSucces: false)
            }
        }
    }
    
    
    
    
    
    
    
    
    
    
}
