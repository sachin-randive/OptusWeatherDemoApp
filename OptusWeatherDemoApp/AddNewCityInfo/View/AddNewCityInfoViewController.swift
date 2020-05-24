//
//  AddNewCityInfoViewController.swift
//  OptusWeatherDemoApp
//
//  Created by Sachin Randive on 24/05/20.
//  Copyright © 2020 Sachin Randive. All rights reserved.
//

import UIKit

class AddNewCityInfoViewController: UIViewController {
    ////MARK: - Outlets
    @IBOutlet weak var cityListTableView: UITableView!
    
    // Declare WeatherInfoViewModel
    fileprivate var newCityInfoViewModel = NewCityInfoViewModel()
    var resultSearchController = UISearchController()
    override func viewDidLoad() {
        super.viewDidLoad()
        newCityInfoViewModel.delegate = self
        newCityInfoViewModel.getCityList()
        initialiseSearchController()
    }
    func initialiseSearchController() {
        resultSearchController = ({
            let controller = UISearchController(searchResultsController: nil)
            controller.searchResultsUpdater = self
            controller.obscuresBackgroundDuringPresentation = false
            controller.searchBar.sizeToFit()
            cityListTableView.tableHeaderView = controller.searchBar
            return controller
        })()
        // Reload the table
        cityListTableView.reloadData()
    }
}
// MARK: - Delegate and DataSource Methods
extension AddNewCityInfoViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.cityListTableCell) as! AddNewCityTableCell
        cell.accessibilityIdentifier = "cityCell_\(indexPath.row)"
        //let citiesName = newCityInfoViewModel.filteredCityList[indexPath.row]
        let citiesName: NewCity
        if resultSearchController.isActive && resultSearchController.searchBar.text != "" {
            citiesName = newCityInfoViewModel.filteredCityList[indexPath.row]
        } else {
            citiesName = newCityInfoViewModel.newCityList[indexPath.row]
        }
        cell.lblCityName?.text = citiesName.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if  (resultSearchController.isActive) {
            return newCityInfoViewModel.filteredCityList.count
        } else {
            return newCityInfoViewModel.newCityList.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
}

// MARK: - NewCityInfoViewModelProtocal Methods
extension AddNewCityInfoViewController: NewCityInfoViewModelProtocal {
    func didUpdateCityInfo() {
        cityListTableView.reloadData()
    }
}

// MARK: - UISearchResultsUpdating Delegate
extension AddNewCityInfoViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        newCityInfoViewModel.filterSelectedEmployee(for: searchController.searchBar.text ?? "", completionHandler: {
            self.cityListTableView.reloadData()
        })
    }
}

