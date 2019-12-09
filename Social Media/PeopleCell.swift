//
//  PeopleCell.swift
//  Social Media
//
//  Created by Mostafa Elshazly on 10/19/19.
//  Copyright © 2019 Mostafa Elshazly. All rights reserved.
//


import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage

class PeopleCell:UICollectionViewCell{
    
    @IBOutlet weak var followButton: UIButton!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileName: UILabel!
    @IBAction func followButtonPressed(_ sender: UIButton) {
        let uuid = UUID().uuidString
        guard let userEmail = Auth.auth().currentUser?.email else { return }
        let dict = [
            "id": uuid,
            "user": userEmail,
            "following": profileName.text!,
            ] as [String : Any]
        followRef.child(uuid).setValue(dict)
        AlertManager.showAlert(title: "Success", message: "User Followed", target: parentViewController!)
        followButton.isHidden = true
    }
    let followRef = Database.database().reference(withPath: "follows")
    let ref = Database.database().reference(withPath: "posts")
    let storage = Storage.storage()
    lazy var storageRef = storage.reference()
    
    func setupCell(user:String) {
        profileName.text = user
        let imgRef = self.storageRef.child("profileImages/\(user).jpg")
        imgRef.getData(maxSize: 10 * 1024 * 1024) { (data, error) in
            if let error = error {
                print("Error found! :\(error.localizedDescription)")
            } else {
                self.profileImage.image = UIImage(data: data!)
            }
        }
    }
    
}
