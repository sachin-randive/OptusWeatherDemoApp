//
//  DetailInfoViewModel.swift
//  OptusWeatherDemoApp
//
//  Created by Sachin Randive on 26/05/20.
//  Copyright © 2020 Sachin Randive. All rights reserved.
//

import Foundation

protocol DetailInfoViewModelProtocal {
    func didUpdateDetailsWeatherInfo()
    func didErrorDetailsDisplay()
}

class DetailInfoViewModel: NSObject {
    var detailsDelegate: DetailInfoViewModelProtocal?
    var weatherDeatilsInfoList : DetailInfoModel?
    
    //MARK: - getEmployeeList Methods
    func getWeatherInfoList(cityID: String) {
        let urlString = OWAppConfig.BaseURL + OWAppConfig.weather +  "id=\(cityID)&units=\(OWConstants.UNIT)&APPID=\(OWAppConfig.API_KEY)"
        
        ServiceManager.shared.getWeatherInfo(urlString: urlString, completionHandler: { (result: Result<DetailInfoModel?, NetworkError>) in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    guard let response = response  else {
                        self.detailsDelegate?.didErrorDetailsDisplay()
                        return
                    }
                    self.weatherDeatilsInfoList = response
                    self.detailsDelegate?.didUpdateDetailsWeatherInfo()
                }
                
            case .failure(let error):
                print(error.localizedDescription)
                self.detailsDelegate?.didErrorDetailsDisplay()
            }
        })
    }
}
