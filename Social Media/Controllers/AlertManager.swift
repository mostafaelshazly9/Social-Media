//
//  AlertManager.swift
//  Social Media
//
//  Created by Mostafa Elshazly on 10/25/19.
//  Copyright © 2019 Mostafa Elshazly. All rights reserved.
//

import UIKit

class AlertManager: NSObject {
    class func showAlert(title:String?, message:String?, target:UIViewController, completion: (() -> Void)? = nil){
        let alert = UIAlertController(title: title ?? "Notification",
                                      message: message ?? "Unkown",
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        
        target.present(alert, animated: true, completion: completion)
    }
}
