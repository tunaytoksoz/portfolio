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
    private var cdOutput : MockCdViewModelOutput!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        cdServiceProtocol = MockCoreDataService()
        cdOutput = MockCdViewModelOutput()
        sut = coreDataViewModel(cdServiceProtocol: cdServiceProtocol)
        sut.cdOutput = cdOutput
        
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testUpdateView_WhenGetCoredataSucces_ShowPortfolio() throws {
        
        let mockPortfolio = Portfolio(eur: 15, gbp: 49, rub: 4, usd: 50)
        
        cdServiceProtocol.getportfolioMockResult = .success(mockPortfolio)
        
        sut.getPortfolio()
        
        XCTAssertEqual(cdOutput.updateViewArray.first?.eur, 15)
        XCTAssertEqual(cdOutput.updateViewArray.first?.gbp, 49)
        XCTAssertEqual(cdOutput.updateViewArray.first?.rub, 4)
        XCTAssertEqual(cdOutput.updateViewArray.first?.usd, 50)
        XCTAssertEqual(cdOutput.updateViewArray.first?.isSucces, true)
        
    }
    
    func testSavePortfolio_isSucces() throws{
        let mockPortfolio = Portfolio(eur: 15, gbp: 49, rub: 4, usd: 50)
        
        cdServiceProtocol.savePortfolioMockResult = .success(true)
        
        sut.saveObject(portfolio: mockPortfolio)
        
        XCTAssertEqual(sut.retBool, true)
    }
    
    
    
    func testPercentCalculate_Succes() throws {
        let mockPortfolio = Portfolio(eur: 5, gbp: 15, rub: 15, usd: 15)
        
        cdServiceProtocol.getportfolioMockResult = .success(mockPortfolio)
        
        sut.getPortfolio()
        
        sut.getPortfolioPercent()
        
        XCTAssertEqual(sut.eur.value, 10)
    }
    
    
    

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}

class MockCoreDataService : CoreDataServiceProtocol {
    
    var getportfolioMockResult : Result<portfolio.Portfolio, Error>?
    var savePortfolioMockResult : Result<Bool, Error>?
    
    func savePortfolio(portfolio: portfolio.Portfolio, completion: @escaping (Result<Bool, Error>) -> Void) {
        if let result = savePortfolioMockResult {
            completion(result)
        }
    }
    
    func getPortfolio(completion: @escaping (Result<portfolio.Portfolio, Error>) -> Void) {
        if let result = getportfolioMockResult {
            completion(result)
        }
    }
}

class MockCdViewModelOutput : cdViewModelOutput {
    var updateViewArray : [(eur: Double, gbp: Double, rub: Double, usd: Double, isSucces: Bool)] = []
    func updatePortfolioLabels(eur: Double, gbp: Double, rub: Double, usd: Double, isSucces: Bool) {
        updateViewArray.append((eur,gbp,rub,usd,isSucces))
    }
}
