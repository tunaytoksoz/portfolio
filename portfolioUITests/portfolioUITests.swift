//
//  portfolioUITests.swift
//  portfolioUITests
//
//  Created by Tunay Toksöz on 27.02.2023.
//

import XCTest

final class portfolioUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
        
    }

    func testBuyCurrency() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        
        let addButton = app.navigationBars["Portfolio App"].buttons["Add"]
        let selectedItem = app.scrollViews.otherElements.buttons["RUB"]
        
        let elementsQuery = app.alerts["RUB Al"].scrollViews.otherElements
        
        let textField = elementsQuery.collectionViews.textFields.firstMatch
        
        let buyButton = elementsQuery.buttons["Al"]
        let alertOkButton = app.alerts["Başarılı"].scrollViews.otherElements.buttons["Tamam."]
               
        addButton.tap()
        selectedItem.tap()
        textField.tap()
        textField.typeText("100")
        buyButton.tap()
        
        XCTAssertTrue(alertOkButton.exists)
    }
    
    
    func testSellCurrency() throws {
        let app = XCUIApplication()
        app.launch()
        
        let addButton = app.navigationBars["Portfolio App"].buttons["Add"]
        let selectedItem = app.scrollViews.otherElements.buttons["EUR"]
        let elementsQueryBuy = app.alerts["EUR Al"].scrollViews.otherElements
        let textField = elementsQueryBuy.collectionViews.textFields.firstMatch
        let buyButton = elementsQueryBuy.buttons["Al"]
        let alertOkButton = app.alerts["Başarılı"].scrollViews.otherElements.buttons["Tamam."]
        
        
        let eurCell = app.collectionViews.cells.containing(.staticText, identifier:"EUR").element.firstMatch
        let elementsQuery = app.alerts["EUR Sat"].scrollViews.otherElements
         let textFieldSell = elementsQuery.collectionViews.textFields.firstMatch
        let sellButton = elementsQuery.buttons["Sat"]
        let alertOkButtonSell = app.alerts["Başarılı"].scrollViews.otherElements.buttons["Tamam."]
        
        addButton.tap()
        selectedItem.tap()
        textField.tap()
        textField.typeText("100")
        buyButton.tap()
        alertOkButton.tap()
        
        eurCell.tap()
        textFieldSell.tap()
        textFieldSell.typeText("10")
        sellButton.tap()
        
        XCTAssertTrue(alertOkButtonSell.exists)

    }
    
    
    

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
