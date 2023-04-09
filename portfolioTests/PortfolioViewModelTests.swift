//
//  PortfolioViewModelTests.swift
//  portfolioTests
//
//  Created by Tunay Toksöz on 8.04.2023.
//

import XCTest
@testable import portfolio

final class PortfolioViewModelTests: XCTestCase {

    private var sut : PortfolioViewModel!
    private var delegate : MockPortfolioViewControllerDelegate!
    private var coredataService : MockCoreDataService!
    private var networkService : MockNetworkService!
    private var chartGenerator : ChartGenerator!
    private var grouppedData : GroupedData!
    private var calculate : Calculate!
    
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        delegate = MockPortfolioViewControllerDelegate()
        coredataService = MockCoreDataService()
        networkService = MockNetworkService()
        chartGenerator = ChartGenerator()
        grouppedData = GroupedData()
        calculate = Calculate()
        
        sut = PortfolioViewModel(coreDataService: coredataService, networkService: networkService, chartGenerator: chartGenerator, groupedData: grouppedData, calculate: calculate)
        sut.delegate = delegate
    }
    
    
    func testUpdateView_whenAPIReturnSucces_showsCurrencies() throws {
        
      /*
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
       */
        
        let mockCurrencies = Currency(data: [ "CAD": 0.1,
                                              "EUR": 0.2,
                                              "GBP": 0.5,
                                              "USD": 1.0
                                           ]
)
        
        networkService.fetchMockResult = .success(mockCurrencies)

        sut.getCurrency()
        
        XCTAssertEqual(delegate.updateCurrencyLabelsIsSucces, true)
    }
    
    func testUpdateView_whenAPIReturnFailure_showsCurrencies() throws {
        
        networkService.fetchMockResult = .failure(failError(errorMessage: "fail"))

        sut.getCurrency()
        
        XCTAssertEqual(delegate.updateCurrencyLabelsIsSucces, false)
        
    }
    
    func testFillPortfolio_Function_ShowPortfolio_WhenAPIAndCoredataReturnSucces() throws {

        let mockCurrencies = [ "CAD": 0.1,
                               "EUR": 0.2,
                               "GBP": 0.5,
                               "USD": 1.0
                            ]
        
        let mockPortfolio = [Portfolios(name: "CAD", value: 10),
                             Portfolios(name: "EUR", value: 30),
                             Portfolios(name: "GBP", value: 50),
                             Portfolios(name: "USD", value: 20)
                            ]
        
        coredataService.getPortfolioMockResult = .success(mockPortfolio)
        
        sut.fillPortfolio(currencies: mockCurrencies)
        
        XCTAssertEqual(delegate.fillPortfolioCollectionArray, [collectionPortfolio(name: "CAD", price: 10, priceTL: 100),
                                                collectionPortfolio(name: "EUR", price: 30, priceTL: 150),
                                                collectionPortfolio(name: "GBP", price: 50, priceTL: 100),
                                                collectionPortfolio(name: "USD", price: 20, priceTL: 20)
                                               ])
    }
    

    
    func testSavePortfolio_isSucces() throws{
        let mockPortfolio = Portfolios(name: "EUR", value: 35, createdTime: Date(), createdTimeString: "3/3/2023")
        
        coredataService.savePortfolioMockResult = .success(true)
        
        let result = sut.saveTransaction(portfolio: mockPortfolio, curr: 5)
        
        XCTAssertEqual(result, true)
    }
    
    func testSavePortfolio_isFailure() throws{
        let mockPortfolio = Portfolios(name: "EUR", value: 35, createdTime: Date(), createdTimeString: "3/3/2023")
        
        coredataService.savePortfolioMockResult = .success(false)
        
        let result = sut.saveTransaction(portfolio: mockPortfolio, curr: 5)
        
        XCTAssertEqual(result, false)
    }
    
    func testUpdatePieChart_ShowCharts_WhenAPIAndCoredataReturnSucces() throws{
        
        let mockCollectionPortfolio = [collectionPortfolio(name: "EUR", price: 34, priceTL: 500),
                                       collectionPortfolio(name: "GBP", price: 50, priceTL: 100),
                                       collectionPortfolio(name: "USD", price: 65, priceTL: 323)
        ]
        
        sut.createPieChart(collectionArray: mockCollectionPortfolio)
        
        XCTAssertEqual(delegate.updateChartsChartType, .pie)
    }
    
    func testUpdateLastWeekChart_WhenReturnCoredataSucces() throws {
        
        let mockResult = [DailyPortfolios(totalValue: 10, day: Date()),
                          DailyPortfolios(totalValue: 30, day: Date().startOfDay)]
        
        coredataService.getLastWeekTableMockResult = .success(mockResult)
        
        sut.updateLastWeekChart()
        
        XCTAssertEqual(delegate.updateChartsChartType, .barDay)
    }
    
    func testUpdateWeeklySummary_WhenReturnCoredataSucces() throws {
        
        let mockResults = [ [DailyPortfolios(totalValue: 10, day: Date()),
                             DailyPortfolios(totalValue: 30, day: Date().startOfDay)],
                             [DailyPortfolios(totalValue: 10, day: Date()),
                             DailyPortfolios(totalValue: 30, day: Date().startOfDay)],
                             [DailyPortfolios(totalValue: 10, day: Date()),
                             DailyPortfolios(totalValue: 30, day: Date().startOfDay)]
                          ]
        
        coredataService.getWeeklyTableMockResult = .success(mockResults)
        sut.updateWeeklySummaryChart()
        
        XCTAssertEqual(delegate.updateChartsChartType, .barWeek)
    }
    
    func testUpdateMonthlyTable_WhenReturnCoreDataSucces() throws {
        
        let mockResult : [String : [Double]] = ["Oca-2023" : [10.0,10.0,10.0,10.0,10.0],
                                              "Şub-2023" : [20.0,20.0,20.0,20.0,20.0],
                                              "Mar-2023" : [30.0,30.0,30.0,30.0,30.0]
                         ]
        
        coredataService.getMonthlyTableMockResult = .success(mockResult)
        
        sut.updateMonthlyChart()
        
        XCTAssertEqual(delegate.updateChartsChartType, .barMonth)
    }
    
    func testUpdateTransactionTable() throws {
        
        let mockPortfolios = [Portfolios(name: "EUR", value: 35, createdTime: Date(), createdTimeString: "3/3/2023"),
                             Portfolios(name: "EUR", value: 35, createdTime: Date(), createdTimeString: "3/3/2023")
                             ]
        
        coredataService.getTransactionsMockResult = .success(mockPortfolios)
        sut.updateTransactionTable()
        
        XCTAssertEqual(delegate.updateTransactionTablePortfolio, mockPortfolios)
    }


    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}

class MockPortfolioViewControllerDelegate : PortfolioViewControllerDelegate {
    
    var updateCurrencyLabelsIsSucces : Bool?
    func updateCurrencyLabels(keys: [[String]], values: [[Double]], currencies: portfolio.Currency, isSucces: Bool) {
        updateCurrencyLabelsIsSucces = isSucces
    }
    
    var fillPortfolioCollectionArray : [collectionPortfolio]?
    func fillPortfolio(collectionArray: [portfolio.collectionPortfolio], isSucces: Bool) {
        fillPortfolioCollectionArray = collectionArray
    }
    
    var updateTransactionTablePortfolio : [Portfolios]?
    func updateTransactionsTable(porfolio: [portfolio.Portfolios], isSucces: Bool) {
        updateTransactionTablePortfolio = porfolio
    }
    
    var updateChartsChartType : chartType?
    func updateCharts(view: UIView, type: chartType) {
        updateChartsChartType = type
    }
    
}


class MockNetworkService : NetworkServiceProtocol {
    
    var fetchMockResult : Result<Any, Error>?
    
    func getData<T>(url: URL, expecting: T.Type, completion: @escaping (Result<T, Error>) -> Void) where T : Decodable {
        if let result = fetchMockResult{
            completion(result as! (Result<T, Error>))
        }
    }
    
    
  
 
}


class MockCoreDataService : CoreDataServiceProtocol {
    
    var getTransactionsMockResult : Result<[Portfolios], Error>?
    func getTransactions(completion: @escaping (Result<[Portfolios], Error>) -> Void) {
        if let result = getTransactionsMockResult {
            completion(result)
        }
    }
    
    
    var savePortfolioMockResult : Result<Bool, Error>?
    func savePortfolio(portfolio: Portfolios, curr: Double, completion: @escaping (Result<Bool, Error>) -> Void) {
        if let result = savePortfolioMockResult {
            completion(result)
        }
    }
    
    var getPortfolioMockResult : Result<[Portfolios], Error>?
    func getPortfolio(completion: @escaping (Result<[Portfolios], Error>) -> Void) {
        if let result = getPortfolioMockResult {
            completion(result)
        }
    }
    
    func saveDailyTable(totalValue: Double) {
        //
    }
    
    var getLastWeekTableMockResult : Result<[DailyPortfolios], Error>?
    func getLastWeekTable(completion: @escaping (Result<[DailyPortfolios], Error>) -> Void) {
        if let result = getLastWeekTableMockResult{
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


struct failError : Error {
    var errorMessage : String
}

