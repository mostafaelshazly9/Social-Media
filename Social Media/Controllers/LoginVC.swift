//
//  ViewController.swift
//  Social Media
//
//  Created by Mostafa Elshazly on 10/14/19.
//  Copyright © 2019 Mostafa Elshazly. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        LoginManager.verify(email: emailTextField.text!, password: passwordTextField.text!, target: self)
    }
    @IBAction func registerButtonPressed(_ sender: UIButton) {
        LoginManager.register(email: emailTextField.text!, password: passwordTextField.text!, target: self)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped(_:)))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func viewTapped(_ sender: UITapGestureRecognizer? = nil){
        view.endEditing(true)
    }
}


