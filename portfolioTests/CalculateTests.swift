//
//  CalculateTests.swift
//  portfolioTests
//
//  Created by Tunay Toksöz on 29.03.2023.
//

import XCTest
@testable import portfolio

final class CalculateTests: XCTestCase {

    private var sut : Calculate!
    
    override func setUpWithError() throws {
        sut = Calculate()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testCalcuteTLFunction() throws {
        let portfolio = [portfolio(name: "EUR", value: 30.0),
                         portfolio(name: "GBP", value: 25.0),
                         portfolio(name: "PLN", value: 100.0)
                        ]
        let currency = Currency(data: ["EUR": 1,
                                       "GBP":0.5,
                                       "PLN": 0.4,
                                      ])
        
        let result = sut.calculateTL(portfolios: portfolio, currency: currency)
        
        XCTAssertEqual(result, [collectionPortfolio(name: "EUR", price: 30.0, priceTL: 30.0),
                                collectionPortfolio(name: "GBP", price: 25.0, priceTL: 50.0),
                                collectionPortfolio(name: "PLN", price: 100.0, priceTL: 250.0)])
    }
    
    func testCalculatePercentFunction() throws{
        let arrayPortfolio = [collectionPortfolio(name: "EUR", price: 50, priceTL: 500),
                              collectionPortfolio(name: "PLN", price: 40, priceTL: 100),
                              collectionPortfolio(name: "GBP", price: 60, priceTL: 400)]
        
        let result = sut.calculatePercent(collectinArray: arrayPortfolio)
        
        XCTAssertEqual(result, [ "EUR" : 50 , "PLN" : 10, "GBP" : 40 ])
    }
    
    func testCalculateMonthlyAverageFunction() throws {
        
        let data = [ "Mart" : [10.0,20.0,30.0],
                     "Nisan" : [50.0,50.0,50.0],
                     "Mayıs" : [100.0,60.0,80.0]]
        
        let result = sut.calculateMonthlyAverage(data: data)
        
        XCTAssertEqual(result, [ "Mart" : 20, "Nisan" : 50, "Mayıs" : 80])
    }
    
    func testCalculateAverageWeekFunction() throws {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd hh:mm:ss Z"
        
        let data = [[DailyPortfolios(totalValue: 10.0, day: df.date(from: "2023-02-26 21:00:00 +0000")),
                     DailyPortfolios(totalValue: 20.0, day: df.date(from: "2023-02-27 21:00:00 +0000")),
                     DailyPortfolios(totalValue: 30.0, day: df.date(from: "2023-02-28 21:00:00 +0000")),
                     DailyPortfolios(totalValue: 40.0, day: df.date(from: "2023-03-01 21:00:00 +0000")),
                     DailyPortfolios(totalValue: 50.0, day: df.date(from: "2023-03-02 21:00:00 +0000")),
                     DailyPortfolios(totalValue: 60.0, day: df.date(from: "2023-03-03 21:00:00 +0000")),
                     DailyPortfolios(totalValue: 70.0, day: df.date(from: "2023-03-04 21:00:00 +0000"))]]
        
        let result = sut.calculateAverageWeek(array: data)
        
        XCTAssertEqual(result, [DailyPortfolios(totalValue: 40.0, day: df.date(from: "2023-03-04 21:00:00 +0000"))])
    }

}
