//
//  ImageProcessor.swift
//  Social Media
//
//  Created by Mostafa Elshazly on 10/25/19.
//  Copyright © 2019 Mostafa Elshazly. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase
import FirebaseStorage

class ImageProcessor:NSObject{
    lazy var ref = Database.database().reference()
    let storage = Storage.storage()
    lazy var storageRef = storage.reference()
    var imagePath:URL!
    var target:ImageUploader!
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func uploadImage(success: @escaping ()->Void){
        // File located on disk
        guard let localFile = imagePath else { AlertManager.showAlert(title: "Error", message: "Image does not exist on disk", target: target); return}
        
        //current User UID
        guard let userEmail = Auth.auth().currentUser?.email else { AlertManager.showAlert(title: "Error", message:"No user signed in", target: target); return}
        
        // Create a reference to the file you want to upload
        let profileRef = storageRef.child("profileImages/\(userEmail).jpg")
        
        // Upload the file to the path "images/userID.jpg"
        profileRef.putFile(from: localFile, metadata: nil) { metadata, error in
            if error != nil{
                // Uh-oh, an error occurred!
                AlertManager.showAlert(title: "Error", message: error?.localizedDescription ?? "An unknwon error has occured", target: self.target)
                return
            }else{
                success()
            }
        }

    }
    
    class func retrieveImage(for user:String, imageView:UIImageView) {
        let storageRef = Storage.storage().reference()
        let imgRef = storageRef.child("profileImages/\(user).jpg")
        imgRef.getData(maxSize: 10 * 1024 * 1024) { (data, error) in
            if let error = error {
                print("Error found! :\(error.localizedDescription)")
            } else {
                imageView.image = UIImage(data: data!)
            }
        }
    }


}

extension ImageProcessor:UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        
        let imageName = UUID().uuidString
        imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
        
        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)
        }
        target.profileImage.image = info[.editedImage] as? UIImage
        target.dismiss(animated: true)
    }

}
