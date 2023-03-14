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

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        networkService = MockNetworkService()
        currOutput = MockCurrencyViewModelOutput()
        sut = currencyViewModel(networkService: networkService, cdService: cdService)
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
        
        XCTAssertEqual(currOutput.updateViewArray.first?.eur, 10)
        XCTAssertEqual(currOutput.updateViewArray.first?.gbp, 15)
        XCTAssertEqual(currOutput.updateViewArray.first?.rub, 20)
        XCTAssertEqual(currOutput.updateViewArray.first?.usd, 30)
        XCTAssertEqual(currOutput.updateViewArray.first?.isSucces, true)
        
    }
    
    func testUpdateView_whenAPIFailure_showsCurrencies() throws {
        
        networkService.fetchMockResult = .failure(NSError())
        
        sut.getCurrency()
        XCTAssertEqual(currOutput.updateViewArray.first?.eur, 0)
        XCTAssertEqual(currOutput.updateViewArray.first?.gbp, 0)
        XCTAssertEqual(currOutput.updateViewArray.first?.rub, 0)
        XCTAssertEqual(currOutput.updateViewArray.first?.usd, 0)
        XCTAssertEqual(currOutput.updateViewArray.first?.isSucces, false)
        
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
    func updateCurrencyLabels(keys: [[String]], values: [[Double]], isSucces: Bool) {
        //
    }
    
    func fillPortfolio(collectionArray: [collectionPortfolio]) {
        //
    }
    
    func updatePiechart(view: UIView) {
        //
    }
    
    func convertTL(eur: Double, gbp: Double, rub: Double, usd: Double) {
        //
    }
    
    func updatePiechart(eur: Double, gbp: Double, rub: Double, usd: Double) {
        //
    }
    
    var updateViewArray : [(eur: Double, gbp: Double, rub: Double, usd: Double, isSucces: Bool)] = []
    func updateCurrencyLabels(eur: Double, gbp: Double, rub: Double, usd: Double, isSucces: Bool) {
        updateViewArray.append((eur,gbp,rub,usd,isSucces))
    }
}
