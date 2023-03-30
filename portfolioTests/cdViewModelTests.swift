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
    private var cdServiceProtocol : MockCoreDataService!
    private var calculate : MockCalculate!
    private var chartGenerator : MockChartGenerator!
    private var groupedData : MockGroupedData!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        cdServiceProtocol = MockCoreDataService()
       
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    
    func testSavePortfolio_isSucces() throws{
        let mockPortfolio = portfolio(name: "EUR", value: 35, createdTime: Date(), createdTimeString: "3/3/2023")
        
        cdServiceProtocol.savePortfolioMockResult = .success(true)
        
        sut.saveObject(portfolio: mockPortfolio, curr: 5)
        
        XCTAssertEqual(sut.retBool, true)
    }
    

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}

class MockCoreDataService : CoreDataServiceProtocol {
    func savePortfolio(portfolio: portfolio, curr: Double, completion: @escaping (Result<Bool, Error>) -> Void) {
        //
    }
    
    func saveDailyTable(totalValue: Double) {
        //
    }
    
    func getDailyTable(completion: @escaping (Result<[DailyPortfolios], Error>) -> Void) {
        //
    }
    
    func getWeeklyTable(completion: @escaping (Result<[[DailyPortfolios]], Error>) -> Void) {
        //
    }
    
    func getMonthlyTable(completion: @escaping (Result<[String : [Double]], Error>) -> Void) {
        //
    }
    
    func getPortfolioWithDayFilter(date: String, completion: @escaping (Result<[DailyPortfolios], Error>) -> Void) {
        //
    }
    
    
    var savePortfolioMockResult : Result<Bool, Error>?
    
    func savePortfolio(portfolio: portfolio, completion: @escaping (Result<Bool, Error>) -> Void) {
        if let result = savePortfolioMockResult {
            completion(result)
        }
    }
    
    func getPortfolio(completion: @escaping (Result<[portfolio], Error>) -> Void) {
        //
    }
    
    /**
     func getPortfolio(completion: @escaping (Result<portfolio.portfolio, Error>) -> Void) {
         if let result = getportfolioMockResult {
             completion(result)
         }
     }
     */
}
