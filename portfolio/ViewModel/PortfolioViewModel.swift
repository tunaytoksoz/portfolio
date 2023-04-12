//
//  PortfolioViewModel.swift
//  portfolio
//
//  Created by Tunay Toksöz on 8.04.2023.
//

import Foundation
import CoreData

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
                        let keys : [[String]] = self.groupedData.groupedKeys(array: Array(currencies.data.keys))
                        let values : [[Double]] = self.groupedData.groupedValues(array: Array(currencies.data.values))
                        
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
    
    
    func saveTransaction(portfolio : Portfolios, curr : Double) -> Bool{
        let returnBool = self.coreDataService.savePortfolio(portfolio: portfolio, curr: curr)
        
        if returnBool {
            var total = UserDefaults.standard.object(forKey: "totalValue") as! Double
            total += portfolio.value / curr
            self.coreDataService.saveDailyTable(totalValue: total)
        }
        
        return returnBool
    }
    
    
    func fillPortfolio(currencies : [String : Double]) {
        var collectionArray : [collectionPortfolio] = [collectionPortfolio]()
        var portArray : [Portfolios] = [Portfolios]()
        var nameTotals : [String : Double] = [:]
        var total : Double = 0
        
        let fetchRequest : NSFetchRequest<Portfolio> = Portfolio.fetchRequest()
        
        coreDataService.getPortfolio(fetchRequest: fetchRequest, completion: { result in
            switch result {
            case .success(let portfolios):
                for port in portfolios {
                    if let name = port.name as? String, let amount = port.value as? Double  {
                               if let currentTotal = nameTotals[name] {
                                   nameTotals[name] = currentTotal + amount
                               } else {
                                   nameTotals[name] = amount
                               }
                           }
                }
                
                for (name, total) in nameTotals {
                    portArray.append(Portfolios(name: name, value: total))
                    UserDefaults.standard.setValue(total, forKey: name)
                }
                
                UserDefaults.standard.synchronize()
                collectionArray = self.calculate.calculateTL(portfolios: portArray, currency: currencies)
                
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
        })
    }
    
    

    func updateTransactionTable(){
        
        let fetchRequest : NSFetchRequest<Portfolio> = Portfolio.fetchRequest()
        fetchRequest.fetchLimit = 10
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "createdTime", ascending: false)]
        
        coreDataService.getPortfolio(fetchRequest: fetchRequest, completion: { result in
            switch result {
            case .success(let portfolio):
                self.delegate?.updateTransactionsTable(porfolio: portfolio, isSucces: true)
            case .failure(let error):
                print(error.localizedDescription)
                self.delegate?.updateTransactionsTable(porfolio: [], isSucces: false)
            }
        })
    }
    
    func createPieChart(collectionArray : [collectionPortfolio]){
        let percentArray = self.calculate.calculatePercent(collectinArray: collectionArray)
        
        let view = chartGenerator.createPieChart(percentArray: percentArray)
        
        self.delegate?.updateCharts(view: view, type: .pie)
    }
    
    func updateLastWeekChart(){
        let fetchRequest : NSFetchRequest<DailyPortfolio> = DailyPortfolio.fetchRequest()
        let calendar = Calendar.current
        let today = Date().startOfDay
        let firstDay = calendar.date(byAdding: .day, value: -6, to: today)!
        
        let sortDescriptor = NSSortDescriptor(key: "day", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.predicate = NSPredicate(format: "day >= %@", firstDay as NSDate)
        
        coreDataService.getDailyPorfolios(fetchRequest: fetchRequest) { result in
            switch result {
            case .success(let values):
                let view = self.chartGenerator.createDailyBarChart(values: values)
                self.delegate?.updateCharts(view: view, type: .barDay)
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }
    
    func updateWeeklySummaryChart(){
        let fetchRequest : NSFetchRequest<DailyPortfolio> = DailyPortfolio.fetchRequest()
        var weeklyTotals : [[DailyPortfolios]] = [[DailyPortfolios]]()
        
        let calendar = Calendar.current
        let lastDayofWeek = calendar.date(byAdding: .weekOfYear, value: -1, to: Date().endOfWeek)!
        let firstDayofWeeksOneMonthAgo = calendar.date(byAdding: .weekOfMonth, value: -4, to: lastDayofWeek)!

        let sortDescriptor = NSSortDescriptor(key: "day", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.predicate = NSPredicate(format: "day > %@ AND day < %@", firstDayofWeeksOneMonthAgo as NSDate, lastDayofWeek as NSDate)
        
        coreDataService.getDailyPorfolios(fetchRequest: fetchRequest) { result in
            switch result {
            case .success(let success):
                weeklyTotals = self.groupedData.groupedWeek(array: success)
                let value = self.calculate.calculateAverageWeek(array: weeklyTotals)
                let view = self.chartGenerator.createWeeklyBarChart(values: value)
                self.delegate?.updateCharts(view: view, type: .barWeek)
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
        
    }
    
    func updateMonthlyChart() {
        let fetchRequest : NSFetchRequest<DailyPortfolio> = DailyPortfolio.fetchRequest()
        
        let sortDescriptor = NSSortDescriptor(key: "day", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        coreDataService.getDailyPorfolios(fetchRequest: fetchRequest) { result in
            switch result {
            case .success(let success):
                let months = self.groupedData.groupedMonth(array: success)
                let value = self.calculate.calculateMonthlyAverage(data: months)
                let view = self.chartGenerator.createMonthlyBarChart(data: value)
                self.delegate?.updateCharts(view: view, type: .barMonth)

            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }
}
