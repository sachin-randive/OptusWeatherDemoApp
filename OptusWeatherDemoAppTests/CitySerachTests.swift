//
//  CitySerachTests.swift
//  OptusWeatherDemoAppTests
//
//  Created by Sachin Randive on 27/05/20.
//  Copyright © 2020 Sachin Randive. All rights reserved.
//

import XCTest
@testable import OptusWeatherDemoApp

class CitySerachTests: XCTestCase {
    // Declaration newCityInfoViewModel
    var newCityInfoViewModel = NewCityInfoViewModel()
    
    override func setUp() {
        let bundle = Bundle.main.url(forResource: "citylist", withExtension: "json")
        let jsonData = try! Data.init(contentsOf: bundle!)
        let results = try! JSONDecoder().decode([NewCity].self, from: jsonData)
        newCityInfoViewModel.newCityList = results
        newCityInfoViewModel.filteredCityList = newCityInfoViewModel.newCityList
    }
    
    override func tearDown() {
        newCityInfoViewModel.filteredCityList = []
        newCityInfoViewModel.newCityList = []
    }
    
    func testNewCityInfoViewModelBothArrayIsEqual() {
        let newCityList = newCityInfoViewModel.newCityList.count
        let filteredCityList = newCityInfoViewModel.filteredCityList.count
        XCTAssertEqual(newCityList, filteredCityList)
    }
    
    func testCityDataNotNil() {
        let city = newCityInfoViewModel.filteredCityList[0]
        XCTAssertNotNil(city)
        XCTAssertEqual(city.id, 14256)
        XCTAssertEqual(city.name, "Azadshahr")
    }
    
    func testCityNameSearchResult() {
        newCityInfoViewModel.searchEmployee(with: "pune") {
            XCTAssertEqual(self.newCityInfoViewModel.filteredCityList.count, 1)
        }
        let newCity = newCityInfoViewModel.filteredCityList[0]
        XCTAssertEqual(newCity.id, 1259229)
        XCTAssertEqual(newCity.name, "Pune")
    }
}
