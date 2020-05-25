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
    @IBOutlet weak var detailInfoTableView: UICollectionView!
    var selectedWeatherInfo:List?
    override func viewDidLoad() {
        super.viewDidLoad()
        print(selectedWeatherInfo ?? "")
        weatherImage.image = UIImage(named: String(describing: (selectedWeatherInfo?.weather[0].main)!))
        weatherDescription.text = String(describing: (selectedWeatherInfo?.weather[0].weatherDescription)!)
    }
    
    //MARK: getWeatherDetailInfo
    private func getWeatherDetailInfo(row : Int)-> (detailText:String,nameOfImage:String) {
        var dataText = ""
        var imageName = ""
        
        switch row {
        case 0:
            dataText = "\(String(describing: (selectedWeatherInfo?.main.humidity)!))%"
            imageName = "humidity"
        case 1:
            dataText = "\(String(describing: (selectedWeatherInfo?.main.tempMax)!))°%"
            imageName = "temp_max"
        case 2:
            dataText = "\(String(describing: (selectedWeatherInfo?.main.tempMin)!))°%"
            imageName = "temp_min"
        case 3:
            dataText = "\(String(describing: (selectedWeatherInfo?.wind?.speed)!))m/s"
            imageName = "windspeed"
        case 4:
            let date = NSDate(timeIntervalSince1970: TimeInterval((selectedWeatherInfo?.sys.sunrise)!))
            dataText = getTimeStringFromDate(date: date as Date)
            imageName = "sunrise"
        case 5:
            let date = NSDate(timeIntervalSince1970: TimeInterval((selectedWeatherInfo?.sys.sunset)!))
            dataText = getTimeStringFromDate(date: date as Date)
            imageName = "sunset"
        default:
            dataText = "\(String(describing: (selectedWeatherInfo?.main.humidity)!))%"
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

extension DetailWeatherInfoViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifiers.DetailWeatherInfoCell, for: indexPath) as! DetailWeatherInfoCell
        let weatherInfo = self.getWeatherDetailInfo(row: indexPath.row)
        cell.detailInfoImage.image = UIImage(named: weatherInfo.nameOfImage)
        cell.detailInfoText.text = weatherInfo.detailText
        performCellAnimation(cell: cell)
        return cell
    }
}
