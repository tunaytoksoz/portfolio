//
//  cdViewModelTests.swift
//  portfolioTests
//
//  Created by Tunay Toksöz on 2.03.2023.
//

import XCTest
@testable import portfolio

final class cdViewModelTests: XCTestCase {

    private var sut : coreDataViewModel!
    private var cdOutput : MockCdViewModelOutput!
    private var cdServiceProtocol : MockCoreDataService!
    private var networkService : MockNetworkService!
    private var calculate : Calculate!
    private var chartGenerator : ChartGenerator!
    private var groupedData : GroupedData!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        cdServiceProtocol = MockCoreDataService()
        networkService = MockNetworkService()
        chartGenerator = ChartGenerator()
        calculate = Calculate()
        groupedData = GroupedData()
        cdOutput = MockCdViewModelOutput()
        sut = coreDataViewModel(cdServiceProtocol: cdServiceProtocol, networkServiceProtocol: networkService, chartGenerator: chartGenerator, groupedData: groupedData, calculate: calculate)
        sut.cdOutput = cdOutput
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    
    func testSavePortfolio_isSucces() throws{
        let mockPortfolio = portfolio(name: "EUR", value: 35, createdTime: Date(), createdTimeString: "3/3/2023")
        
        cdServiceProtocol.savePortfolioMockResult = .success(true)
        
        let result = sut.saveObject(portfolio: mockPortfolio, curr: 5)
        
        XCTAssertEqual(result, true)
    }
    
    func testSavePortfolio_isFailure() throws{
        let mockPortfolio = portfolio(name: "EUR", value: 35, createdTime: Date(), createdTimeString: "3/3/2023")
        
        cdServiceProtocol.savePortfolioMockResult = .success(false)
        
        let result = sut.saveObject(portfolio: mockPortfolio, curr: 5)
        
        XCTAssertEqual(result, false)
    }
    
    func testUpdateTransactionTable() throws {
        let mockPortfolios = [portfolio(name: "EUR", value: 35, createdTime: Date(), createdTimeString: "3/3/2023"),
                             portfolio(name: "EUR", value: 35, createdTime: Date(), createdTimeString: "3/3/2023")
                             ]
        cdServiceProtocol.getTransactionsMockResult = .success(mockPortfolios)
        sut.updateTransactionTable()
        
        XCTAssertTrue(cdOutput.isDoneTransaction!)
    }
    
    func testUpdateWeekChart_WhenReturnCoredataSucces() throws {
        
        let mockResults = [DailyPortfolios(totalValue: 10, day: Date()),
                           DailyPortfolios(totalValue: 30, day: Date().startOfDay)
                          ]
        
        cdServiceProtocol.getDailyTableMockResult = .success(mockResults)
        sut.updateWeekChart()
        
      //  XCTAssertEqual(cdOutput.isDone, true)
    }
    
    func testUpdateWeekChart_WhenReturnCoredataFailure() throws {
        
        let mockResults = [DailyPortfolios(totalValue: 10, day: Date()),
                           DailyPortfolios(totalValue: 30, day: Date().startOfDay)
                          ]
        
        cdServiceProtocol.getDailyTableMockResult = .failure(failError(errorMessage: "Error"))
        sut.updateWeekChart()
        
        XCTAssertEqual(cdOutput.isDone, false)
    }
    
    
    

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}

class MockCoreDataService : CoreDataServiceProtocol {
    
    var getTransactionsMockResult : Result<[portfolio], Error>?
    func getTransactions(completion: @escaping (Result<[portfolio], Error>) -> Void) {
        if let result = getTransactionsMockResult {
            completion(result)
        }
    }
    
    
    var savePortfolioMockResult : Result<Bool, Error>?
    func savePortfolio(portfolio: portfolio, curr: Double, completion: @escaping (Result<Bool, Error>) -> Void) {
        if let result = savePortfolioMockResult {
            completion(result)
        }
    }
    
    var getPortfolioMockResult : Result<[portfolio], Error>?
    func getPortfolio(completion: @escaping (Result<[portfolio], Error>) -> Void) {
        if let result = getPortfolioMockResult {
            completion(result)
        }
    }
    
    func saveDailyTable(totalValue: Double) {
        //
    }
    
    var getDailyTableMockResult : Result<[DailyPortfolios], Error>?
    func getDailyTable(completion: @escaping (Result<[DailyPortfolios], Error>) -> Void) {
        if let result = getDailyTableMockResult{
            completion(result)
        }
    }
    
    var getWeeklyTableMockResult : Result<[[DailyPortfolios]], Error>?
    func getWeeklyTable(completion: @escaping (Result<[[DailyPortfolios]], Error>) -> Void) {
        if let result = getWeeklyTableMockResult {
            completion(result)
        }
    }
    
    var getMonthlyTableMockResult : Result<[String : [Double]], Error>?
    func getMonthlyTable(completion: @escaping (Result<[String : [Double]], Error>) -> Void) {
        if let result = getMonthlyTableMockResult{
            completion(result)
        }
    }
    
    var getPortfolioWithDayFilterTableMockResult : Result<[DailyPortfolios], Error>?
    func getPortfolioWithDayFilter(date: String, completion: @escaping (Result<[DailyPortfolios], Error>) -> Void) {
        if let result = getPortfolioWithDayFilterTableMockResult {
            completion(result)
        }
    }
}


class MockCdViewModelOutput : cdViewModelOutput {
    var isDoneTransaction : Bool?
    func updateTransactionsTable(porfolio: [portfolio], isSucces: Bool) {
        isDoneTransaction = isSucces
    }
    
    var isDone = false
    func updateCharts(view: UIView, type: chartType) {
        isDone = true
    }
    
    
}
