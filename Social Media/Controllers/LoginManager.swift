//
//  LoginManager.swift
//  Social Media
//
//  Created by Mostafa Elshazly on 10/25/19.
//  Copyright © 2019 Mostafa Elshazly. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

class LoginManager: NSObject {
    
    class func verify(email:String, password:String, target:UIViewController) {
        Auth.auth().signIn(withEmail: email, password: password) { user, error in
            if let error = error, user == nil {
                //Authentication failed
                AlertManager.showAlert(title: "Sign In Failed", message: error.localizedDescription, target: target)
            }else{
                //Authentication successful
                if let tabViewController = target.storyboard?.instantiateViewController(withIdentifier: "MainTabVC") as? UITabBarController {
                    tabViewController.modalPresentationStyle = .fullScreen //or .overFullScreen for transparency
                    target.dismiss(animated: true) {
                        target.present(tabViewController, animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    class func register(email:String, password:String, target:UIViewController){
        let ref = Database.database().reference(withPath: "users")
        Auth.auth().createUser(withEmail: email, password: password) { user, error in
            //Registration successful
            if error == nil {
                Auth.auth().signIn(withEmail: email,
                                   password: password)
                let uuid = UUID().uuidString
                let dict = [
                    "id": uuid,
                    "user": email
                    ] as [String : Any]
                
                ref.child(uuid).setValue(dict)
                if let vc = target.storyboard?.instantiateViewController(withIdentifier: "ImageUploader") as? ImageUploader {
                    vc.modalPresentationStyle = .fullScreen
                    target.dismiss(animated: true) {
                        target.present(vc,animated: true)
                    }
                }
                
            }else{
                //Registration failed
                AlertManager.showAlert(title: "Error", message: error!.localizedDescription, target: target)
            }
        }
    }
}

