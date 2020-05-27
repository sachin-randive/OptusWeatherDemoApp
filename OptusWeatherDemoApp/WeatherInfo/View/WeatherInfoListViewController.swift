//
//  WeatherInfoListViewController.swift
//  OptusWeatherDemoApp
//
//  Created by Sachin Randive on 22/05/20.
//  Copyright © 2020 Sachin Randive. All rights reserved.
//

import UIKit

class WeatherInfoListViewController: UIViewController {
    //MARK: - Outlets
    @IBOutlet weak var cityWeatherTableView: UITableView!
    @IBOutlet weak var addNewCityBtn: UIBarButtonItem!
    // Declare WeatherInfoViewModel
    fileprivate var weatherInfoViewModel = WeatherInfoViewModel()
    var activityView: UIActivityIndicatorView?
    var apiCallTimer: Timer?
    let gradientLayer = CAGradientLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        weatherInfoViewModel.delegate = self
        getCityInfoList()
        apiCallTimer = Timer.scheduledTimer(timeInterval: 300, target: self, selector: #selector(getCityInfoList), userInfo: nil, repeats: true)
        self.setGradientBackground(gradientLayer:gradientLayer)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        gradientLayer.frame = view.layer.bounds
    }
    
    @objc func getCityInfoList() {
        addActivityIndicator()
        activityView?.startAnimating()
        cityWeatherTableView.accessibilityIdentifier = OWConstants.tableCityWeatherTableView
        addNewCityBtn.accessibilityIdentifier = OWConstants.addNewCityBtn
        self.weatherInfoViewModel.getWeatherInfoList()
    }
    
    // This method is to setup Activity indicator
    func addActivityIndicator() {
        activityView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.whiteLarge)
        activityView?.center =  CGPoint(x: self.view.bounds.midX, y: self.view.bounds.midY)
        activityView?.hidesWhenStopped = true
        view.addSubview(activityView!)
    }
    
    //MARK:- AddNewCityAction
    @IBAction func AddNewCityAction(_ sender: Any) {
        let navToAddNewCityInfoViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddNewCityInfoViewController") as! AddNewCityInfoViewController
        navToAddNewCityInfoViewController.addCityDelegate = self
        self.navigationController?.pushViewController(navToAddNewCityInfoViewController, animated: false)
    }
}

// MARK: - Delegate and DataSource Methods
extension WeatherInfoListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.cityWeatherTableViewCell) as! WeatherInfoTableCell
        cell.accessibilityIdentifier = "myCell_\(indexPath.row)"
        let WeatherInfo = weatherInfoViewModel.weatherInfoList[indexPath.row]
        cell.cityNameLabel?.text = WeatherInfo.name
        cell.cityTemperatureLabel?.text = "\(String(describing: Int(WeatherInfo.main.temp))) °C"
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherInfoViewModel.weatherInfoList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let navToDetailWeatherInfoViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailWeatherInfoViewController") as! DetailWeatherInfoViewController
        navToDetailWeatherInfoViewController.selectedWeatherInfoID = weatherInfoViewModel.weatherInfoList[indexPath.row].id
        self.navigationController?.pushViewController(navToDetailWeatherInfoViewController, animated: false)
    }
}

// MARK: - Delegate Methods of WeatherInfoViewModelProtocal
extension WeatherInfoListViewController: WeatherInfoViewModelProtocal {
    
    func didUpdateWeatherInfo() {
        activityView?.stopAnimating()
        cityWeatherTableView.reloadData()
    }
    
    func didErrorDisplay() {
        DispatchQueue.main.async {
            self.activityView?.stopAnimating()
            self.alert(message:OWConstants.errorMessage, title: OWConstants.Error)
        }
    }
}
// MARK: - AddNewEmployeeViewControllerProtocal Delegate - refresh after new employee record added
extension WeatherInfoListViewController: AddNewCityInfoViewControllerProtocal {
    
    func didGoBackAndReloadTableData() {
        self.weatherInfoViewModel.getWeatherInfoList()
    }
}
