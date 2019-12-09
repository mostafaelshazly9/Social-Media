//
//  UserProfile.swift
//  Social Media
//
//  Created by Mostafa Elshazly on 10/20/19.
//  Copyright © 2019 Mostafa Elshazly. All rights reserved.
//

import UIKit
import MobileCoreServices

class UserProfile:UIViewController{

    @IBOutlet weak var postTextView: UITextView!
    @IBAction func postPressed(_ sender: UIButton) {
//        if attachmentURL != nil{
//            do{
//                let url = try String(contentsOf: attachmentURL!)
//                postManager.addPost(text: postTextView.text, type: currentMediaType, attachmentURL: url, postsCollectionView: postsCollectionView)
//            }catch let error{
//                AlertManager.showAlert(title: "Error", message: error.localizedDescription, target: self)
//            }
//        }else{
//            postManager.addPost(text: postTextView.text, type: currentMediaType, attachmentURL: nil, postsCollectionView: postsCollectionView)

//        }
        postManager.addPost(text: postTextView.text, type: currentMediaType, attachmentURL: attachmentURL, postsCollectionView: postsCollectionView)
        postTextView.text = ""
        AlertManager.showAlert(title: "Success", message: "Post posted successfully", target: self)
        postManager.loadPosts(postsCollectionView: postsCollectionView)
    }
    @IBOutlet weak var postsCollectionView: UICollectionView!
    @IBAction func attachButtonPressed(_ sender: UIButton) {
        let alert = UIAlertController(title: "Pick attachment type", message: nil, preferredStyle: .actionSheet)
        let action1 = UIAlertAction(title: "Image", style: .default) { (UIAlertAction) in
            self.pickImage(of: .image)
        }
        let action2 = UIAlertAction(title: "Video", style: .default) { (UIAlertAction) in
            self.pickImage(of: .movie)
        }
        let action3 = UIAlertAction(title: "Document", style: .default) { (UIAlertAction) in
            self.pickFile()
        }
        let action4 = UIAlertAction(title: "Cancel", style: .destructive)
        [action1,action2,action3,action4].forEach{ alert.addAction($0) }
        present(alert, animated: true)

    }
    @IBAction func removeAttachmentButtonPressed(_ sender: UIButton) {
        attachmentType = ""
        attachmentURL = nil
    }
    
    var attachmentType = ""
    var attachmentURL:URL?
    var currentMediaType:PostType = .none

    @IBAction func friendRequestsPressed(_ sender: UIButton) {
    }
    let postManager = PostManager.instance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped(_:)))
        view.addGestureRecognizer(tapGesture)
        postManager.setUserAsOnlyFollower()
        postsCollectionView.delegate = postManager
        postsCollectionView.dataSource = postManager
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        postManager.loadPosts(postsCollectionView: postsCollectionView)
    }
    
    @objc func viewTapped(_ sender: UITapGestureRecognizer? = nil){
        view.endEditing(true)
    }
        func pickImage(of type:PostType){
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary){
                let picker = UIImagePickerController()
    //            picker.allowsEditing = true
                picker.delegate = self
                picker.mediaTypes = ["public.\(type.rawValue)"]
                currentMediaType = type
                self.present(picker, animated: true, completion: nil)
            }
        }
        
        func pickFile(){
            let types: [String] = [kUTTypePDF as String]
            let documentPicker = UIDocumentPickerViewController(documentTypes: types, in: .import)
            documentPicker.delegate = self
            documentPicker.modalPresentationStyle = .formSheet
            self.present(documentPicker, animated: true, completion: nil)
        }
    
    func createTemporaryURLforVideoFile(url: NSURL) -> NSURL {
        /// Create the temporary directory.
        let temporaryDirectoryURL = URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)
        /// create a temporary file for us to copy the video to.
        let temporaryFileURL = temporaryDirectoryURL.appendingPathComponent(url.lastPathComponent ?? "")
        /// Attempt the copy.
        do {
            try FileManager().copyItem(at: url.absoluteURL!, to: temporaryFileURL)
        } catch {
            print("There was an error copying the video file to the temporary location.")
        }

        return temporaryFileURL as NSURL
    }


}

extension UserProfile:UIDocumentPickerDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
         // you get from the urls parameter the urls from the files selected
        attachmentType = "document"
        attachmentURL = urls[0]
        currentMediaType = .document

//        do{
//            try attachmentURL = String(contentsOf: urls[0])
//        }catch let error{
//            AlertManager.showAlert(title: "Error", message: error.localizedDescription, target: self)
//        }
    }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    //        guard (info[.editedImage] as? UIImage) != nil else { return }
            if currentMediaType == .image{
            attachmentURL = info[.imageURL] as? URL
            print(info[.imageURL]!)
            }else if currentMediaType == .movie{
                attachmentURL =  createTemporaryURLforVideoFile(url: info[UIImagePickerController.InfoKey.mediaURL] as! NSURL) as URL
                print(attachmentURL!)
            }
            dismiss(animated: true)
            attachmentType = currentMediaType.rawValue
        }
}
