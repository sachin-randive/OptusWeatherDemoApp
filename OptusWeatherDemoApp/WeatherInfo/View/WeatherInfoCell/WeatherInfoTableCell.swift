//
//  WeatherInfoTableCell.swift
//  OptusWeatherDemoApp
//
//  Created by Sachin Randive on 23/05/20.
//  Copyright © 2020 Sachin Randive. All rights reserved.
//

import UIKit

class WeatherInfoTableCell: UITableViewCell {
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var cityTemperatureLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
