//
//  WeatherInfoViewModel.swift
//  OptusWeatherDemoApp
//
//  Created by Sachin Randive on 22/05/20.
//  Copyright © 2020 Sachin Randive. All rights reserved.
//

import Foundation

protocol WeatherInfoViewModelProtocal {
    func didUpdateWeatherInfo()
    func didErrorDisplay()
}

class WeatherInfoViewModel: NSObject {
    var delegate: WeatherInfoViewModelProtocal?
    var weatherInfoList : [List]  = []
    
    //MARK: - getEmployeeList Methods
    func getWeatherInfoList() {
        let urlString = OWAppConfig.BaseURL + "id=\(OWAppConfig.Sydney),\(OWAppConfig.Melbourne),\(OWAppConfig.Brisbane)&units=\(OWConstants.UNIT)&APPID=\(OWAppConfig.API_KEY)"
        ServiceManager.shared.getWeatherInfo(urlString: urlString, completionHandler: { (result: Result<WeatherInfo?, NetworkError>) in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    guard let response = response  else {
                        self.delegate?.didErrorDisplay()
                        return
                    }
                    self.weatherInfoList = response.list
                    self.delegate?.didUpdateWeatherInfo()
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        })
    }
}
