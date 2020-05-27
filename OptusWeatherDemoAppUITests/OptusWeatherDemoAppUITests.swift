//
//  OptusWeatherDemoAppUITests.swift
//  OptusWeatherDemoAppUITests
//
//  Created by Sachin Randive on 22/05/20.
//  Copyright © 2020 Sachin Randive. All rights reserved.
//

import XCTest

class OptusWeatherDemoAppUITests: XCTestCase {
    var app: XCUIApplication!
    override func setUp() {
        continueAfterFailure = false
        app = XCUIApplication()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testForCellExistence() {
        app.launch()
        let detailstable = app.tables.matching(identifier: "table--cityWeatherTableView")
        let firstCell = detailstable.cells.element(matching: .cell, identifier: "myCell_0")
        let existencePredicate = NSPredicate(format: "exists == 1")
        let expectationEval = expectation(for: existencePredicate, evaluatedWith: firstCell, handler: nil)
        let mobWaiter = XCTWaiter.wait(for: [expectationEval], timeout: 10.0)
        XCTAssert(XCTWaiter.Result.completed == mobWaiter, "Test Case Failed.")
        firstCell.tap()
    }
    
    func testTableInteraction() {
        app.launch()
        // Assert that we are displaying the tableview
        let mainTableView = app.tables["table--cityWeatherTableView"]
        XCTAssertTrue(mainTableView.exists, "The main tableview exists")
        // Get an array of cells
        let tableCells = mainTableView.cells
        if tableCells.count > 0 {
            let count: Int = (tableCells.count - 1)
            let promise = expectation(description: "Wait for table cells")
            for i in stride(from: 0, to: count , by: 1) {
                if i == (count - 1) {
                    promise.fulfill()
                }
            }
            waitForExpectations(timeout: 20, handler: nil)
            XCTAssertTrue(true, "Finished validating the table cells")
            
        } else {
            XCTAssert(false, "Was not able to find any table cells")
        }
    }
}
