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
    private var calculate : Calculate!
    private var chartGenerator : ChartGenerator!
    private var groupedData : GroupedData!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        networkService = MockNetworkService()
        cdService = MockCoreDataService()
        calculate = Calculate()
        chartGenerator = ChartGenerator()
        groupedData = GroupedData()
        currOutput = MockCurrencyViewModelOutput()
        sut = currencyViewModel(networkService: networkService, cdService: cdService, calculate: calculate, chartGenerator: chartGenerator, groupedData: groupedData)
        sut.output = currOutput
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testUpdateView_whenAPIReturnSucces_showsCurrencies() throws {
        
        let mockCurrencies =  """
                            {
                              "data": {
                                "CAD": 0.070308,
                                "EUR": 0.048202,
                                "GBP": 0.042383,
                                "USD": 0.052086
                              }
                            }
                            """.data(using: .utf8)!
        
        
        networkService.fetchMockResult = .success(mockCurrencies)

        sut.getCurrency()
        
        XCTAssertEqual(currOutput.updateCurrencyisSucces, true)
        
    }
    
    func testUpdateView_whenAPIReturnFailure_showsCurrencies() throws {
        
        networkService.fetchMockResult = .failure(failError(errorMessage: "fail"))

        sut.getCurrency()
        
        XCTAssertEqual(currOutput.updateCurrencyisSucces, false)
        
    }
    
    func testConvertTLFunction_ShowPortfolio_WhenAPIAndCoredataReturnSucces() throws {
        let mockCurrencies =  """
                            {
                              "data": {
                                "CAD": 0.1,
                                "EUR": 0.2,
                                "GBP": 0.5,
                                "USD": 1.0
                              }
                            }
                            """.data(using: .utf8)!
        
        let mockPortfolio = [portfolio(name: "CAD", value: 10),
                             portfolio(name: "EUR", value: 30),
                             portfolio(name: "GBP", value: 50),
                             portfolio(name: "USD", value: 20)
                            ]
        
        networkService.fetchMockResult = .success(mockCurrencies)
        cdService.getPortfolioMockResult = .success(mockPortfolio)
        
        sut.convertPortfolio()
        
        XCTAssertEqual(currOutput.collections, [collectionPortfolio(name: "CAD", price: 10, priceTL: 100),
                                                collectionPortfolio(name: "EUR", price: 30, priceTL: 150),
                                                collectionPortfolio(name: "GBP", price: 50, priceTL: 100),
                                                collectionPortfolio(name: "USD", price: 20, priceTL: 20)
                                               ])
    }
    
    func testUpdatePieChart_ShowCharts_WhenAPIAndCoredataReturnSucces() throws{
        let mockCurrencies =  """
                            {
                              "data": {
                                "CAD": 0.1,
                                "EUR": 0.2,
                                "GBP": 0.5,
                                "USD": 1.0
                              }
                            }
                            """.data(using: .utf8)!
        
        let mockPortfolio = [portfolio(name: "CAD", value: 10),
                             portfolio(name: "EUR", value: 30),
                             portfolio(name: "GBP", value: 50),
                             portfolio(name: "USD", value: 20)
                            ]
        
        networkService.fetchMockResult = .success(mockCurrencies)
        cdService.getPortfolioMockResult = .success(mockPortfolio)
        
        sut.updatePieChart()
        
       // XCTAssertEqual(currOutput.viewType, .pie)
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
        if let result = fetchMockResult {
            completion(result)
        }
    }
}




class MockCurrencyViewModelOutput : currencyViewModelOutput {
    var updateCurrencyisSucces : Bool?
    func updateCurrencyLabels(keys: [[String]], values: [[Double]], currencies: [String : Double], isSucces: Bool) {
        updateCurrencyisSucces = isSucces
    }
    
    var collections : [collectionPortfolio]?
    func fillPortfolio(collectionArray: [collectionPortfolio]) {
        collections = collectionArray
    }
    var viewType : chartType?
    func updateCharts(view: UIView, type: chartType) {
        viewType = type
    }
}

struct failError : Error {
    var errorMessage : String
}


