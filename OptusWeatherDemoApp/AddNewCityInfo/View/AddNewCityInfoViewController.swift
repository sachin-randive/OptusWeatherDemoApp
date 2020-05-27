//
//  AddNewCityInfoViewController.swift
//  OptusWeatherDemoApp
//
//  Created by Sachin Randive on 24/05/20.
//  Copyright © 2020 Sachin Randive. All rights reserved.
//

import UIKit
import RealmSwift

protocol AddNewCityInfoViewControllerProtocal {
    func didGoBackAndReloadTableData()
}

class AddNewCityInfoViewController: UIViewController {
    ////MARK: - Outlets
    @IBOutlet weak var cityListTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    // Declare WeatherInfoViewModel
    fileprivate var newCityInfoViewModel = NewCityInfoViewModel()
    let gradientLayer = CAGradientLayer()
    var addCityDelegate: AddNewCityInfoViewControllerProtocal?
    var activityView: UIActivityIndicatorView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newCityInfoViewModel.delegate = self
        view.accessibilityIdentifier = OWConstants.AddNewCity_Dashboard
        self.setGradientBackground(gradientLayer: gradientLayer)
        let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.backgroundColor = UIColor.black
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        addActivityIndicator()
        activityView?.startAnimating()
        searchBar.text = ""
        dismissKeyboard()
        searchBar.accessibilityIdentifier = OWConstants.searchBarIndentifier
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
            self.newCityInfoViewModel.getCityList()
        })
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        gradientLayer.frame = view.layer.bounds
    }
    
    func dismissKeyboard() {
        DispatchQueue.main.async {
            self.searchBar.resignFirstResponder()
        }
    }
    
    // This method is to setup Activity indicator
    func addActivityIndicator() {
        activityView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.whiteLarge)
        activityView?.center =  CGPoint(x: self.view.bounds.midX, y: self.view.bounds.midY)
        activityView?.hidesWhenStopped = true
        view.addSubview(activityView!)
    }
}

// MARK: - Delegate and DataSource Methods
extension AddNewCityInfoViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.cityListTableCell) as! AddNewCityTableCell
        cell.accessibilityIdentifier = "cityCell_\(indexPath.row)"
        //let citiesName = newCityInfoViewModel.filteredCityList[indexPath.row]
        let citiesName: NewCity
        activityView?.stopAnimating()
        citiesName = newCityInfoViewModel.filteredCityList[indexPath.row]
        cell.lblCityName?.text = citiesName.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newCityInfoViewModel.filteredCityList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let citiesName: NewCity
        citiesName = newCityInfoViewModel.filteredCityList[indexPath.row]
        let firstCityInfoModel = NewCityInfoModel()
        firstCityInfoModel.id = "\(citiesName.id)"
        firstCityInfoModel.name = citiesName.name
        if DatabaseManager.sharedInstance.searchNameIfExistInDatabase(id: "\(citiesName.id)") == nil {
            DatabaseManager.sharedInstance.addCityInfoData(object: firstCityInfoModel)
            self.popupAlert(title: OWConstants.success, message:OWConstants.sucessMessage, actionTitles: ["OK"], actions:[{action1 in
                DispatchQueue.main.async {
                    self.addCityDelegate?.didGoBackAndReloadTableData()
                    self.navigationController?.popViewController(animated: true)
                } }, nil])
        } else {
            self.alert(message:OWConstants.alreadyExist, title: "")
        }
    }
}

// MARK: - NewCityInfoViewModelProtocal Methods
extension AddNewCityInfoViewController: NewCityInfoViewModelProtocal {
    
    func didUpdateCityInfo() {
        cityListTableView.reloadData()
    }
}

//MARK: - UISearchBar Delegate
extension AddNewCityInfoViewController: UISearchBarDelegate {
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        return true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        dismissKeyboard()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        newCityInfoViewModel.searchEmployee(with: searchText) {
            self.cityListTableView.reloadData()
            if searchText.isEmpty {
                self.dismissKeyboard()
            }
        }
    }
}

