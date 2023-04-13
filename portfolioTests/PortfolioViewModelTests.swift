//
//  PortfolioViewModelTests.swift
//  portfolioTests
//
//  Created by Tunay Toksöz on 8.04.2023.
//

import XCTest
import CoreData
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
        
        sut = PortfolioViewModel(coreDataService: coredataService, networkService: networkService,
                                 chartGenerator: chartGenerator, groupedData: grouppedData, calculate: calculate)
        sut.delegate = delegate
    }
    
    
    func testUpdateView_whenAPIReturnSucces_showsCurrencies() throws {
        
        let mockCurrencies = Currency(data: [ "CAD": 0.1,
                                              "EUR": 0.2,
                                              "GBP": 0.5,
                                              "USD": 1.0
                                           ])
        
        networkService.fetchMockResult = .success(mockCurrencies)

        sut.getCurrency()
        
        XCTAssertEqual(delegate.updateCurrencyLabelsIsSucces, true)
    }
    
    func testUpdateView_whenAPIReturnFailure_showsCurrencies() throws {
        
        networkService.fetchMockResult = .failure(.invalidData)

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
        
        XCTAssertTrue(((delegate.fillPortfolioCollectionArray?.contains(collectionPortfolio(name: "CAD", price: 10, priceTL: 100.0))) != nil))
        XCTAssertTrue(((delegate.fillPortfolioCollectionArray?.contains(collectionPortfolio(name: "EUR", price: 30, priceTL: 150.0))) != nil))
        XCTAssertTrue(((delegate.fillPortfolioCollectionArray?.contains(collectionPortfolio(name: "GBP", price: 50, priceTL: 100.0))) != nil))
        XCTAssertTrue(((delegate.fillPortfolioCollectionArray?.contains(collectionPortfolio(name: "USD", price: 20, priceTL: 20.0))) != nil))
    }


    
    func testSavePortfolio_isSucces() throws{
        let mockPortfolio = Portfolios(name: "EUR", value: 35, createdTime: Date(), createdTimeString: "3/3/2023")
       
        coredataService.savePortfolioBool = true
        let result = sut.saveTransaction(portfolio: mockPortfolio, curr: 5)
        
        XCTAssertEqual(result, true)
    }
    
    func testSavePortfolio_isFailure() throws{
        let mockPortfolio = Portfolios(name: "EUR", value: 35, createdTime: Date(), createdTimeString: "3/3/2023")
        
        coredataService.savePortfolioBool = false
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
        
        coredataService.getDailyPorfoliosMockResult = .success(mockResult)
        
        sut.updateLastWeekChart()
        
        XCTAssertEqual(delegate.updateChartsChartType, .barDay)
    }
    
    func testUpdateWeeklySummary_WhenReturnCoredataSucces() throws {
        
        let mockResults = [DailyPortfolios(totalValue: 10, day: Date()),
                           DailyPortfolios(totalValue: 30, day: Date().startOfDay),
                           DailyPortfolios(totalValue: 50, day: Date().endOfWeek),
                           DailyPortfolios(totalValue: 60, day: Date().startOfDay),
                           DailyPortfolios(totalValue: 70, day: Date()),
                           DailyPortfolios(totalValue: 30, day: Date().startOfDay)
                          ]
        
        coredataService.getDailyPorfoliosMockResult = .success(mockResults)
        
        sut.updateWeeklySummaryChart()
        
        XCTAssertEqual(delegate.updateChartsChartType, .barWeek)
    }
    
    func testUpdateMonthlyTable_WhenReturnCoreDataSucces() throws {
        
        let mockResult = [DailyPortfolios(totalValue: 10, day: Date()),
                                                DailyPortfolios(totalValue: 30, day: Date().startOfDay),
                                                DailyPortfolios(totalValue: 50, day: Date().endOfWeek),
                                                DailyPortfolios(totalValue: 60, day: Date().startOfDay),
                                                DailyPortfolios(totalValue: 70, day: Date()),
                                                DailyPortfolios(totalValue: 30, day: Date().startOfDay)
                                               ]
        
        coredataService.getDailyPorfoliosMockResult = .success(mockResult)
        
        sut.updateMonthlyChart()
        
        XCTAssertEqual(delegate.updateChartsChartType, .barMonth)
    }
    
    func testUpdateTransactionTable() throws {
        
        let mockPortfolios = [Portfolios(name: "EUR", value: 35, createdTime: Date(), createdTimeString: "3/3/2023"),
                             Portfolios(name: "EUR", value: 35, createdTime: Date(), createdTimeString: "3/3/2023")
                             ]
        
        coredataService.getPortfolioMockResult = .success(mockPortfolios)
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
    
    var fetchMockResult : Result<Any, RequestError>?
    
    func getData<T>(url: URL, expecting: T.Type, completion: @escaping (Result<T, RequestError>) -> Void) where T : Decodable {
        if let result = fetchMockResult{
            completion(result as! (Result<T, RequestError>))
        }
    }
}


class MockCoreDataService : CoreDataServiceProtocol {
    func saveDailyTable(totalValue: Double) {
        //
    }
    
    var savePortfolioBool : Bool = true
    func savePortfolio(portfolio: portfolio.Portfolios, curr: Double) -> Bool {
        return savePortfolioBool
    }
    
    var getPortfolioMockResult : Result<[Portfolios], Error>?
    func getPortfolio(fetchRequest: NSFetchRequest<portfolio.Portfolio>, completion: @escaping (Result<[portfolio.Portfolios], Error>) -> Void) {
        if let result = getPortfolioMockResult {
            completion(result)
        }
    }
    
    var getDailyPorfoliosMockResult : Result<[DailyPortfolios], Error>?
    func getDailyPorfolios(fetchRequest: NSFetchRequest<portfolio.DailyPortfolio>, completion: @escaping (Result<[portfolio.DailyPortfolios], Error>) -> Void) {
        if let result = getDailyPorfoliosMockResult{
            completion(result)
        }
    }
}


struct failError : Error {
    var errorMessage : String
}

