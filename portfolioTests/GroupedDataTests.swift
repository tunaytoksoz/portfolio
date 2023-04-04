//
//  GroupedDataTests.swift
//  portfolioTests
//
//  Created by Tunay Toksöz on 29.03.2023.
//

import XCTest
@testable import portfolio
final class GroupedDataTests: XCTestCase {

    private var sut : GroupedData!
    
    override func setUpWithError() throws {
        sut = GroupedData()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    
    func testGroupedKeysFunction() throws {
        let mockData = ["1","2","3","4","5","6","7","8"]
        
        let result = sut.groupedKeys(array: mockData)
        
        XCTAssertEqual(result, [["1","2","3","4"],
                                ["5","6","7","8"]
                               ])
    }
    
    func testGroupedValues() throws {
        let mockData = [1.0,2.0,3.0,4.0,5.0,6.0,7.0,8.0]
        
        let result = sut.groupedValues(array: mockData)
        
        XCTAssertEqual(result, [[1.0,2.0,3.0,4.0],
                                [5.0,6.0,7.0,8.0]
                               ])
    }
    
    func testGroupedWeekFunction() throws {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd hh:mm:ss Z"
        
        let mockData = [DailyPortfolios(totalValue: 20.0, day: df.date(from: "2023-02-20 21:00:00 +0000")),
                        DailyPortfolios(totalValue: 30.0, day: df.date(from: "2023-02-21 21:00:00 +0000")),
                        DailyPortfolios(totalValue: 50.0, day: df.date(from: "2023-02-22 21:00:00 +0000")),
                        DailyPortfolios(totalValue: 50.0, day: df.date(from: "2023-02-23 21:00:00 +0000")),
                        DailyPortfolios(totalValue: 60.0, day: df.date(from: "2023-02-24 21:00:00 +0000")),
                        DailyPortfolios(totalValue: 95.0, day: df.date(from: "2023-02-25 21:00:00 +0000")),
                        DailyPortfolios(totalValue: 100.0, day: df.date(from: "2023-02-26 21:00:00 +0000")),
                        DailyPortfolios(totalValue: 55.0, day: df.date(from: "2023-02-27 21:00:00 +0000")),
                        DailyPortfolios(totalValue: 30.0, day: df.date(from: "2023-02-28 21:00:00 +0000")),
                        DailyPortfolios(totalValue: 60.0, day: df.date(from: "2023-03-01 21:00:00 +0000")),
                        DailyPortfolios(totalValue: 50.0, day: df.date(from: "2023-03-02 21:00:00 +0000")),
                        DailyPortfolios(totalValue: 60.0, day: df.date(from: "2023-03-03 21:00:00 +0000")),
                        DailyPortfolios(totalValue: 70.0, day: df.date(from: "2023-03-04 21:00:00 +0000")),
                        DailyPortfolios(totalValue: 10.0, day: df.date(from: "2023-03-05 21:00:00 +0000"))]
        
        let result = sut.groupedWeek(array: mockData)
        
        
        XCTAssertEqual(result, [[DailyPortfolios(totalValue: 20.0, day: df.date(from: "2023-02-20 21:00:00 +0000")),
                                 DailyPortfolios(totalValue: 30.0, day: df.date(from: "2023-02-21 21:00:00 +0000")),
                                 DailyPortfolios(totalValue: 50.0, day: df.date(from: "2023-02-22 21:00:00 +0000")),
                                 DailyPortfolios(totalValue: 50.0, day: df.date(from: "2023-02-23 21:00:00 +0000")),
                                 DailyPortfolios(totalValue: 60.0, day: df.date(from: "2023-02-24 21:00:00 +0000")),
                                 DailyPortfolios(totalValue: 95.0, day: df.date(from: "2023-02-25 21:00:00 +0000")),
                                 DailyPortfolios(totalValue: 100.0, day: df.date(from: "2023-02-26 21:00:00 +0000"))],
                                
                                 [DailyPortfolios(totalValue: 55.0, day: df.date(from: "2023-02-27 21:00:00 +0000")),
                                 DailyPortfolios(totalValue: 30.0, day: df.date(from: "2023-02-28 21:00:00 +0000")),
                                 DailyPortfolios(totalValue: 60.0, day: df.date(from: "2023-03-01 21:00:00 +0000")),
                                 DailyPortfolios(totalValue: 50.0, day: df.date(from: "2023-03-02 21:00:00 +0000")),
                                 DailyPortfolios(totalValue: 60.0, day: df.date(from: "2023-03-03 21:00:00 +0000")),
                                 DailyPortfolios(totalValue: 70.0, day: df.date(from: "2023-03-04 21:00:00 +0000")),
                                 DailyPortfolios(totalValue: 10.0, day: df.date(from: "2023-03-05 21:00:00 +0000"))]])
        
        
    }
    
    func testGroupedMonthFunction() throws {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        
        let mockData = [DailyPortfolios(totalValue: 10, day: df.date(from: "2023.01.01")),
                        DailyPortfolios(totalValue: 10, day: df.date(from: "2023.01.02")),
                        DailyPortfolios(totalValue: 10, day: df.date(from: "2023.01.03")),
                        DailyPortfolios(totalValue: 10, day: df.date(from: "2023.01.04")),
                        DailyPortfolios(totalValue: 10, day: df.date(from: "2023.01.05")),
                        DailyPortfolios(totalValue: 20, day: df.date(from: "2023.02.01")),
                        DailyPortfolios(totalValue: 20, day: df.date(from: "2023.02.02")),
                        DailyPortfolios(totalValue: 20, day: df.date(from: "2023.02.03")),
                        DailyPortfolios(totalValue: 20, day: df.date(from: "2023.02.04")),
                        DailyPortfolios(totalValue: 20, day: df.date(from: "2023.02.05")),
                        DailyPortfolios(totalValue: 30, day: df.date(from: "2023.03.01")),
                        DailyPortfolios(totalValue: 30, day: df.date(from: "2023.03.02")),
                        DailyPortfolios(totalValue: 30, day: df.date(from: "2023.03.03")),
                        DailyPortfolios(totalValue: 30, day: df.date(from: "2023.03.04")),
                        DailyPortfolios(totalValue: 30, day: df.date(from: "2023.03.05")),
                        ]
        
        let result = sut.groupedMonth(array: mockData)
        
        XCTAssertEqual(result, ["Oca-2023" : [10,10,10,10,10],
                                "Şub-2023" : [20,20,20,20,20],
                                "Mar-2023" : [30,30,30,30,30]
                               ])
        
    }

}
