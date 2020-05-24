//
//  NewCityInfoViewModel.swift
//  OptusWeatherDemoApp
//
//  Created by Sachin Randive on 24/05/20.
//  Copyright © 2020 Sachin Randive. All rights reserved.
//

import Foundation
import UIKit
protocol NewCityInfoViewModelProtocal {
    func didUpdateCityInfo()
}

class NewCityInfoViewModel: NSObject {
    var delegate: NewCityInfoViewModelProtocal?
    var newCityList : [NewCity]  = []
    var filteredCityList: [NewCity]  = []
    
    //MARK:- Filter Logic on searchbar
    func filterSelectedEmployee(for searchText: String, completionHandler: @escaping ()-> Void) {
        filteredCityList = newCityList.filter { filteredList in
            return (filteredList.name.lowercased() as AnyObject).contains(searchText.lowercased())
        }
        completionHandler()
    }
    
    //MARK: - getCityList Methods
    func getCityList() {
        if let url = Bundle.main.url(forResource: "citylist", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode([NewCity].self, from: data)
                newCityList = jsonData
            } catch {
                print("error:\(error)")
            }
        }
    }
}
