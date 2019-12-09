//
//  ImageUploader.swift
//  Social Media
//
//  Created by Mostafa Elshazly on 10/17/19.
//  Copyright © 2019 Mostafa Elshazly. All rights reserved.
//

import UIKit

class ImageUploader:UIViewController{
    
    var imageProcessor = ImageProcessor()
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBAction func addImageButton(_ sender: UIButton) {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = imageProcessor
        present(picker,animated: true)
    }
    
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        imageProcessor.uploadImage {
            self.goToMainVC()
        }
    }
    
    @IBAction func skipButtonPressed(_ sender: UIButton) {
        goToMainVC()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageProcessor.target = self
    }
    
    func goToMainVC(){
        if let tabViewController = self.storyboard?.instantiateViewController(withIdentifier: "MainTabVC") as? UITabBarController {
            tabViewController.modalPresentationStyle = .fullScreen //or .overFullScreen for transparency
            self.present(tabViewController, animated: true)
        }
    }
}
