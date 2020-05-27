//
//  DetailWeatherInfoViewController.swift
//  OptusWeatherDemoApp
//
//  Created by Sachin Randive on 24/05/20.
//  Copyright © 2020 Sachin Randive. All rights reserved.
//

import UIKit

class DetailWeatherInfoViewController: UIViewController {
    //MARK: - Outlets
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var weatherDescription: UILabel!
    @IBOutlet weak var cityNameLbl: UILabel!
    @IBOutlet weak var currentTempLbl: UILabel!
    @IBOutlet weak var feelLikesLbl: UILabel!
    @IBOutlet weak var detailInfoTableView: UICollectionView!
    
    fileprivate var detailInfoViewModel = DetailInfoViewModel()
    var activityView: UIActivityIndicatorView?
    let gradientLayer = CAGradientLayer()
    var selectedWeatherInfoID: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        detailInfoViewModel.detailsDelegate = self
        getCityInfoList()
        self.setGradientBackground(gradientLayer: gradientLayer)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        gradientLayer.frame = view.layer.bounds
    }
    
    func getCityInfoList() {
        addActivityIndicator()
        activityView?.startAnimating()
        detailInfoViewModel.getWeatherInfoList(cityID: String(describing: selectedWeatherInfoID!))
    }
    
    // This method is to setup Activity indicator
    func addActivityIndicator() {
        activityView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.whiteLarge)
        activityView?.center =  CGPoint(x: self.view.bounds.midX, y: self.view.bounds.midY)
        activityView?.hidesWhenStopped = true
        view.addSubview(activityView!)
    }
    
    //MARK: getWeatherDetailInfo
    private func getWeatherDetailInfo(row : Int)-> (detailText:String,nameOfImage:String) {
        var dataText = ""
        var imageName = ""
        switch row {
        case 0:
            dataText = "\((detailInfoViewModel.weatherDeatilsInfoList?.main.humidity)!)%" 
            imageName = "humidity"
        case 1:
            dataText = "\(Int((detailInfoViewModel.weatherDeatilsInfoList?.main.tempMax)!)) °C"
            imageName = "temp_max"
        case 2:
            dataText = "\(Int((detailInfoViewModel.weatherDeatilsInfoList?.main.tempMin)!)) °C"
            imageName = "temp_min"
        case 3:
            var windSpeed = Double((detailInfoViewModel.weatherDeatilsInfoList?.wind?.speed) ?? 00)
            windSpeed = windSpeed.roundToDecimal(1)
            dataText = "\(windSpeed) m/s"
            imageName = "windspeed"
        case 4:
            let date = NSDate(timeIntervalSince1970: TimeInterval((detailInfoViewModel.weatherDeatilsInfoList?.sys.sunrise)!))
            dataText = getTimeStringFromDate(date: date as Date)
            imageName = "sunrise"
        case 5:
            let date = NSDate(timeIntervalSince1970: TimeInterval((detailInfoViewModel.weatherDeatilsInfoList?.sys.sunset)!))
            dataText = getTimeStringFromDate(date: date as Date)
            imageName = "sunset"
        case 6:
            dataText = "\((detailInfoViewModel.weatherDeatilsInfoList?.main.pressure)!) mb"
            imageName = "pressure"
        case 7:
            var value =  Double((detailInfoViewModel.weatherDeatilsInfoList?.visibility) ?? 00) / 1000
            if value == 0.0 {
                dataText = "NA"
            } else {
                value = value.roundToDecimal(1)
                dataText = "\(value) Km"
            }
            imageName = "visibility"
        default:
            dataText = "\((detailInfoViewModel.weatherDeatilsInfoList?.main.humidity)!)%"
            imageName = "humidity"
        }
        
        return (dataText,imageName)
    }
    
    //MARK:- Animation
    private func performCellAnimation(cell:DetailWeatherInfoCell) {
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 5, options: [],
                       animations: {
                        cell.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        }, completion: { finished in
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 3, options: .curveEaseInOut,  animations: {
                cell.transform = CGAffineTransform(scaleX: 1, y: 1)
            },    completion: nil
            )
        }
        )
    }
    
    // get date from string
    private func getTimeStringFromDate(date : Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        let dataString = dateFormatter.string(from: date)
        return dataString
    }
}

// MARK: - Delegate and DataSource Methods
extension DetailWeatherInfoViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifiers.DetailWeatherInfoCell, for: indexPath) as! DetailWeatherInfoCell
        if detailInfoViewModel.weatherDeatilsInfoList != nil {
            let weatherInfo = self.getWeatherDetailInfo(row: indexPath.row)
            cell.detailInfoImage.image = UIImage(named: weatherInfo.nameOfImage)
            cell.detailInfoText.text = weatherInfo.detailText
            cell.infoText.text = weatherInfo.nameOfImage
            performCellAnimation(cell: cell)
        }
        return cell
    }
}

// MARK: - DetailInfoViewModelProtocal Methods
extension DetailWeatherInfoViewController: DetailInfoViewModelProtocal {
    
    func didUpdateDetailsWeatherInfo() {
        activityView?.stopAnimating()
        detailInfoTableView.reloadData()
        print(detailInfoViewModel.weatherDeatilsInfoList as Any)
        weatherImage.image =  UIImage(named: String(describing:((detailInfoViewModel.weatherDeatilsInfoList?.weather[0].main)!))) ?? UIImage(named: "deafult_One")
        weatherDescription.text = String(describing: (detailInfoViewModel.weatherDeatilsInfoList?.weather[0].weatherDescription)!)
        cityNameLbl.text = detailInfoViewModel.weatherDeatilsInfoList!.name + " (\(detailInfoViewModel.weatherDeatilsInfoList?.sys.country ?? ""))"
        currentTempLbl.text = "\(String(describing: Int((detailInfoViewModel.weatherDeatilsInfoList?.main.temp)!))) °C"
        feelLikesLbl.text = "FeelsLike: \(String(describing:Int((detailInfoViewModel.weatherDeatilsInfoList?.main.feelsLike)!))) °C"
    }
    
    func didErrorDetailsDisplay() {
        DispatchQueue.main.async {
            self.activityView?.stopAnimating()
            self.alert(message:OWConstants.errorMessage, title: OWConstants.Error)
        }
    }
}
