//
//  NewCityInfoModel.swift
//  OptusWeatherDemoApp
//
//  Created by Sachin Randive on 24/05/20.
//  Copyright © 2020 Sachin Randive. All rights reserved.
//

import Foundation
import RealmSwift

class NewCityInfoModel: Object {
    @objc dynamic var id = ""
    @objc dynamic var name = ""
}

//MARK:- NewCity for getting city from local JSON
struct NewCity: Decodable {
    let id: Int
    let name: String
}
