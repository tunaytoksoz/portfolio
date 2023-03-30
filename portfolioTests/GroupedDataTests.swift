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
        let MockData = ["1","2","3","4","5","6","7","8"]
        
        let result = sut.groupedKeys(array: MockData)
        
        XCTAssertEqual(result, [["1","2","3","4"],["5","6","7","8"]])
    }
    
    func testGroupedValues() throws {
        let MockData = [1.0,2.0,3.0,4.0,5.0,6.0,7.0,8.0]
        
        let result = sut.groupedValues(array: MockData)
        
        XCTAssertEqual(result, [[1.0,2.0,3.0,4.0], [5.0,6.0,7.0,8.0]])
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
