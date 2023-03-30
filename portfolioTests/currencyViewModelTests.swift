//
//  currencyViewM odelTests.swift
//  portfolioTests
//
//  Created by Tunay Toksöz on 2.03.2023.
//

import XCTest
@testable import portfolio

final class currencyViewModelTests: XCTestCase {
    
    private var sut : currencyViewModel!
    private var networkService : MockNetworkService!
    private var cdService : MockCoreDataService!
    private var currOutput : MockCurrencyViewModelOutput!
    private var calculate : MockCalculate!
    private var chartGenerator : MockChartGenerator!
    private var groupedData : MockGroupedData!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        networkService = MockNetworkService()
        currOutput = MockCurrencyViewModelOutput()
        sut = currencyViewModel(networkService: networkService, cdService: cdService, calculate: calculate, chartGenerator: chartGenerator, groupedData: groupedData)
        sut.output = currOutput
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testUpdateView_whenAPISucces_showsCurrencies() throws {
        
        let mockCurrencies = Currency(data: ["EUR" : 19.232])
        
        do {
            let data = try JSONEncoder().encode(mockCurrencies)
            networkService.fetchMockResult = .success(data)
        } catch{}
        
                
        sut.getCurrency()
        
    
        
    }
    
    func testUpdateView_whenAPIFailure_showsCurrencies() throws {
        
        networkService.fetchMockResult = .failure(NSError())
        
        sut.getCurrency()
        
        
    }


    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}

class MockNetworkService : NetworkServiceProtocol {
    var fetchMockResult : Result<Data, Error>?
    
    func getData(url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
        if let result = fetchMockResult{
            completion(result)
        }
    }
}

class MockCurrencyViewModelOutput : currencyViewModelOutput {
    func updateCurrencyLabels(keys: [[String]], values: [[Double]], currencies: [String : Double], isSucces: Bool) {
        //
    }
    
    func fillPortfolio(collectionArray: [collectionPortfolio]) {
        //
    }
    
    func updateCharts(view: UIView, type: chartType) {
        //
    }
}

class MockCalculate: CalculateProtocol {
    func calculatePercent(collectinArray: [collectionPortfolio]) -> [String : Double] {
        //
        return [ String : Double ]()
    }
    
    func calculateTL(portfolios: [portfolio], currency: Currency) -> [collectionPortfolio] {
        //
        return [collectionPortfolio]()
    }
    
    func calculateAverageWeek(array: [[DailyPortfolios]]) -> [DailyPortfolios] {
        //
        return [DailyPortfolios]()
    }
    
    func calculateMonthlyAverage(data: [String : [Double]]) -> [String : Double] {
        //
        return [ String : Double ]()
    }
}

class MockChartGenerator: ChartGeneratorProtocol {
    func createPieChart(percentArray: [String : Double], output: currencyViewModelOutput) {
        //
    }
    
    func createDailyBarChart(values: [DailyPortfolios], cdOutput: cdViewModelOutput) {
        //
    }
    
    func createWeekBarChart(values: [DailyPortfolios], cdOutput: cdViewModelOutput) {
        //
    }
    
    func createMonthlyBarChart(data: [String : Double], cdOutput: cdViewModelOutput) {
        //
    }
}
class MockGroupedData: GroupedDataProtocol {
    func groupedKeys(array: [String]) -> [[String]] {
        //
        return [[String]]()
    }
    
    func groupedValues(array: [Double]) -> [[Double]] {
        //
        return [[Double]]()
    }
    
    func groupedWeek(array: [DailyPortfolios]) -> [[DailyPortfolios]] {
        //
        return [[DailyPortfolios]]()
    }
    
    func groupedMonth(array: [DailyPortfolios]) -> [String : [Double]] {
        //
        return [String : [Double]]()
    }
}
