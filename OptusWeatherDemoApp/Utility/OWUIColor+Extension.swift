//
//  OWUIColor+Extension.swift
//  OptusWeatherDemoApp
//
//  Created by Sachin Randive on 26/05/20.
//  Copyright © 2020 Sachin Randive. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    static let colorTop =  UIColor(red: 140.0/255.0, green: 40.0/255.0, blue: 90.0/255.0, alpha: 1.0).cgColor
    static let colorBottom = UIColor(red:224.0/255.0, green: 88.0/255.0, blue:70.0/255.0, alpha: 1.0).cgColor
}

extension UIViewController {
    func setGradientBackground(gradientLayer: CAGradientLayer) {
        gradientLayer.colors = [UIColor.colorTop, UIColor.colorBottom]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = view.bounds
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
}

extension Double {
    func roundToDecimal(_ fractionDigits: Int) -> Double {
        let multiplier = pow(10, Double(fractionDigits))
        return Darwin.round(self * multiplier) / multiplier
    }
}
