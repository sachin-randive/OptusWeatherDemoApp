//
//  DatabaseManager.swift
//  OptusWeatherDemoApp
//
//  Created by Sachin Randive on 24/05/20.
//  Copyright © 2020 Sachin Randive. All rights reserved.
//

import Foundation
import RealmSwift

class DatabaseManager {
    private var database:Realm
    static let sharedInstance = DatabaseManager()
    
    private init() {
        database = try! Realm()
        print(Realm.Configuration.defaultConfiguration.fileURL!)
    }
    
    func getCityInfoDataFromDB() -> Results<NewCityInfoModel> {
        let results: Results<NewCityInfoModel> = database.objects(NewCityInfoModel.self)
        return results
    }
    
    func addCityInfoData(object: NewCityInfoModel) {
        try! database.write {
            database.add(object)
        }
    }
    func searchNameIfExistInDatabase(name: String) -> NewCityInfoModel? {
        let predicate = NSPredicate(format: "name = %@", name )
        let nameObject = database.objects(NewCityInfoModel.self).filter(predicate).first
        
        if nameObject?.name == name {
            return nameObject
        }
        return nil
    }
}
