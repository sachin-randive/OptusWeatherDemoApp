//
//  OWToastMessage.swift
//  OptusWeatherDemoApp
//
//  Created by Sachin Randive on 24/05/20.
//  Copyright © 2020 Sachin Randive. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
   func alert(message: String, title: String ) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func popupAlert(title: String?, message: String?, actionTitles:[String?], actions:[((UIAlertAction) -> Void)?]) {
           let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
           for (index, title) in actionTitles.enumerated() {
               let action = UIAlertAction(title: title, style: .default, handler: actions[index])
               alert.addAction(action)
           }
           self.present(alert, animated: true, completion: nil)
       }
}
