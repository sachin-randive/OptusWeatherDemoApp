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
        app.launch()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testForCellExistence() {
        let detailstable = app.tables.matching(identifier: "table--cityWeatherTableView")
        let firstCell = detailstable.cells.element(matching: .cell, identifier: "myCell_0")
        let existencePredicate = NSPredicate(format: "exists == 1")
        let expectationEval = expectation(for: existencePredicate, evaluatedWith: firstCell, handler: nil)
        let mobWaiter = XCTWaiter.wait(for: [expectationEval], timeout: 10.0)
        XCTAssert(XCTWaiter.Result.completed == mobWaiter, "Test Case Failed.")
        firstCell.tap()
    }
    
    func testTableInteraction() {
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
    
    //MARK :- add New city  UI testing Start here.
    /* #################################################################################
    //MARK:- NOTE : For UI tesing, Please change the citylist.json files to citySeachUITesting.json in NewCityInfoViewModel.getCityList() function
       ################################################################################# */
    
    func test_AddNewRecordPage_SearchCity() {
        let app = XCUIApplication()
        app.navigationBars["Weather Report"].buttons["addNewCityBtn"].tap()
        let enterCityNameSearchField = app/*@START_MENU_TOKEN@*/.searchFields["Enter City Name"]/*[[".otherElements[\"AddNewCity_Dashboard\"].searchFields[\"Enter City Name\"]",".searchFields[\"Enter City Name\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        enterCityNameSearchField.tap()
        enterCityNameSearchField.typeText("Kashm")
        app.tables.staticTexts["Kashmar"].tap()
        app.alerts["Success"].scrollViews.otherElements.buttons["OK"].tap()
    }
}


