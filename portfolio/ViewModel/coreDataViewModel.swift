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
    private let chartGenerator : ChartGenerator
    private let groupedData : GroupedData
    private let calculate : Calculate

    weak var cdOutput : cdViewModelOutput?
    
    private var baseUrl = "https://api.freecurrencyapi.com/v1/"
    
    init(cdServiceProtocol: CoreDataServiceProtocol, networkServiceProtocol: NetworkServiceProtocol, chartGenerator: ChartGenerator, groupedData: GroupedData, calculate: Calculate, cdOutput: cdViewModelOutput? = nil ) {
        self.cdServiceProtocol = cdServiceProtocol
        self.networkServiceProtocol = networkServiceProtocol
        self.chartGenerator = chartGenerator
        self.groupedData = groupedData
        self.calculate = calculate
        self.cdOutput = cdOutput
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
    
    func updateWeekChart(){
        var values : [DailyPortfolios] = [DailyPortfolios]()
        cdServiceProtocol.getDailyTable() { result in
            switch result{
            case .success(let data):
                values = data
                self.chartGenerator.createDailyBarChart(values: values, cdOutput: self.cdOutput!)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func updateWeekSummaryGraphic(){
        cdServiceProtocol.getWeeklyTable() { result in
            switch result {
            case .success(let success):
                print(success)
                let value = self.calculate.calculateAverageWeek(array: success)
                self.chartGenerator.createWeekBarChart(values: value, cdOutput: self.cdOutput!)
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }
    
    func updateMonthlyGraphic() {
        cdServiceProtocol.getMonthlyTable { result in
            switch result {
            case .success(let success):
                let value = self.calculate.calculateMonthlyAverage(data: success)
                self.chartGenerator.createMonthlyBarChart(data: value, cdOutput: self.cdOutput!)
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }
    
}
