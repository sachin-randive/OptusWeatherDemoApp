//
//  WeatherInfoListViewController.swift
//  OptusWeatherDemoApp
//
//  Created by Sachin Randive on 22/05/20.
//  Copyright © 2020 Sachin Randive. All rights reserved.
//

import UIKit
import RSLoadingView
import Reachability

class WeatherInfoListViewController: UIViewController {
    //MARK: - Outlets
    @IBOutlet weak var cityWeatherTableView: UITableView!
    @IBOutlet weak var addButton: UIBarButtonItem!
    // Declare WeatherInfoViewModel
    fileprivate let weatherInfoViewModel = WeatherInfoViewModel()
    //declare Loading View
    let loadingView = RSLoadingView(effectType: RSLoadingView.Effect.twins)
    //declare this property where it won't go out of scope relative to your listener
    let reachability = try! Reachability()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        weatherInfoViewModel.delegate = self
        checkNetworkConnectivity()
    }
    //MARK:- Check Network Connectivity
    func checkNetworkConnectivity() {
        reachability.whenReachable = { reachability in
            if reachability.connection == .wifi ||  reachability.connection == .cellular {
                self.loadingView.show(on: self.view)
                self.weatherInfoViewModel.getWeatherInfoList()
            }
        }
        reachability.whenUnreachable = { _ in
            print("Not reachable")
        }
        
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }
}
// MARK: - Delegate and DataSource Methods
extension WeatherInfoListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.cityWeatherTableViewCell) as! WeatherInfoTableCell
        cell.accessibilityIdentifier = "myCell_\(indexPath.row)"
        let WeatherInfo = weatherInfoViewModel.weatherInfoList[indexPath.row]
        cell.cityNameLabel?.text = WeatherInfo.name
        cell.cityTemperatureLabel?.text = "\(WeatherInfo.main.temp) °C"
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherInfoViewModel.weatherInfoList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

// MARK: - Delegate Methods of WeatherInfoViewModelProtocal
extension WeatherInfoListViewController: WeatherInfoViewModelProtocal {
    func didUpdateWeatherInfo() {
        RSLoadingView.hide(from: view)
        cityWeatherTableView.reloadData()
    }
    
    func didErrorDisplay() {
        
    }
}
