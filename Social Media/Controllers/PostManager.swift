//
//  PostManager.swift
//  Social Media
//
//  Created by Mostafa Elshazly on 10/26/19.
//  Copyright © 2019 Mostafa Elshazly. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase
import FirebaseStorage
import WebKit
import AVKit
import AVFoundation

class PostManager:NSObject{
    let ref = Database.database().reference(withPath: "posts")
    var posts = [Post]()
    let followRef = Database.database().reference(withPath: "follows")
    var followers = [String]()
    static let instance = PostManager()
    
    private override init() {
        
    }
    
    func addPost(text:String,type:PostType,attachmentURL:URL?, postsCollectionView:UICollectionView){
        let uuid = UUID().uuidString
        guard text.count > 0, let userEmail = Auth.auth().currentUser?.email else { return }
        var dict = [
            "id": uuid,
            "poster": userEmail,
            "date": ServerValue.timestamp(),
            "post": text,
            "likers": [String](),
            "comments": [String](),
            "type":type.rawValue,
            ] as [String : Any]
        if attachmentURL != nil{
            uploadFile(from: attachmentURL!, postID: uuid, type: type, fileName: attachmentURL!.lastPathComponent, success: emptyFunc)
            dict["attachmentInfo"] = ["fileName":attachmentURL?.lastPathComponent]
        }
        ref.child("\(Date())---\(uuid)").setValue(dict)
        loadPosts(postsCollectionView:postsCollectionView)
        
    }
    
    func loadPosts(postsCollectionView:UICollectionView){
        ref.observe(.value, with: { snapshot in
            if snapshot.exists() == false {return}
            var newPosts = [Post]()
            for child in snapshot.children{
                
                let post = (child as! DataSnapshot).value  as! [String: Any]
                if  !self.followers.contains(post["poster"] as! String) { continue }
                //                var info = [String:String]()
                if post["attachmentInfo"] != nil{
                    //                    info = post["attachmentInfo"] as! [String:String]
                    let newPost = Post(
                        id: post["id"] as? String,
                        poster: post["poster"] as! String,
                        date: Double(truncating: post["date"] as! NSNumber),
                        post: post["post"] as! String,
                        likers: post["likers"] as? [String],
                        comments: post["comments"] as? [Comment],
                        typeRawValue: post["type"] as? String,
                        attachmentInfo:post["attachmentInfo"] as! [String:String]
                    )
                    newPost.attachmentInfo = post["attachmentInfo"] as! [String:String]
                    newPosts.append(newPost)
                    postsCollectionView.reloadData()
                    
                    
                }else{
                    let newPost = Post(
                        id: post["id"] as? String,
                        poster: post["poster"] as! String,
                        date: Double(truncating: post["date"] as! NSNumber),
                        post: post["post"] as! String,
                        likers: post["likers"] as? [String],
                        comments: post["comments"] as? [Comment],
                        typeRawValue: post["type"] as? String,
                        attachmentInfo:[String:String]()
                        
                        //                    attachmentInfo: info
                    )
                    newPosts.append(newPost)
                    postsCollectionView.reloadData()
                }
                
            }
            self.posts = newPosts
        })
    }
    
    func loadFollows(for user:String? = Auth.auth().currentUser?.email , postsCollectionView:UICollectionView){
        if Auth.auth().currentUser != nil,  !followers.contains((Auth.auth().currentUser?.email)!) { followers.append((Auth.auth().currentUser?.email)!) }
        followRef.observe(.value, with: { snapshot in
            if snapshot.exists() == false {return}
            
            for child in snapshot.children{
                
                let follow = (child as! DataSnapshot).value  as! [String: Any]
                if follow["user"] as? String == user && !self.followers.contains(follow["following"] as! String) {
                    self.followers.append(follow["following"] as! String)
                }
            }
            self.loadPosts(postsCollectionView: postsCollectionView)
        })
    }
    
    func setFollowers(_ followersArray:[String]){
        followers = followersArray
    }
    
    func setUserAsOnlyFollower(){
        followers = [(Auth.auth().currentUser?.email)!]
    }
    
    func uploadFile(from filePath:URL, postID:String, type:PostType, fileName:String, success: @escaping ()->Void){
        let storage = Storage.storage()
        let storageRef = storage.reference()
        
        let fileName = fileName
        // Create a reference to the file you want to upload
        let profileRef = storageRef.child("post\(type.rawValue)/\(postID)\(fileName)")
        profileRef.putFile(from: filePath, metadata: nil) { metadata, error in
            if error != nil{
                // Uh-oh, an error occurred!
                print("Error uploading file:\(error?.localizedDescription)")
                return
            }else{
                success()
            }
        }
        
    }
    
    func retrieveFile(for postID:String,of type:PostType, imageView:UIImageView?, fileButton:UIButton?, videoView: UIView?, completion: ((_ url:URL)->Void)?) {
        let storageRef = Storage.storage().reference()
        //        var fileExtension = ""
        //        switch type {
        //        case .document:
        //            fileExtension = ".txt"
        //        case .image:
        //            fileExtension = ".jpg"
        //        case .movie:
        //            fileExtension = ".mp4"
        //        case .none:
        //            break
        //        }
        let fileExtension = posts.filter{ $0.id == postID  }[0].attachmentInfo["fileName"]
        let fileRef = storageRef.child("post\(type.rawValue)/\(postID)\(fileExtension!)")
        fileRef.getData(maxSize: 10 * 1024 * 1024) { (data, error) in
            if let error = error {
                print("Error found! :\(error.localizedDescription)")
            } else {
                imageView?.image = UIImage(data: data!)
                if fileButton != nil{
                    let activityController = UIActivityViewController(activityItems: [data!], applicationActivities: nil)
                    if let topController = UIApplication.topViewController() {
                        topController.present(activityController, animated: true, completion: nil)
                    }
                }
                if videoView != nil {
                    fileRef.downloadURL { url,error in
                        if error != nil{
                            print(error!.localizedDescription)
                        }else{
//                            let player = AVPlayer(url: url!)
//                            let playerViewController = AVPlayerViewController()
//                            playerViewController.player = player
//                            if let topController = UIApplication.topViewController() {
//                                topController.navigationController?.pushViewController(playerViewController, animated: true)
//                                    playerViewController.player!.play()
//                            }
                            
                            
                            let player = AVPlayer(url: url!)
                            let playerLayer = AVPlayerLayer(player: player)
                            playerLayer.frame = videoView!.bounds
                            videoView!.layer.addSublayer(playerLayer)

//                            player.play()
                            if completion != nil{
                                completion!(url!)
                            }
                        }
                    }
                }
            }
        }
    }
    
    func emptyFunc(){
        
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    
    
}

extension PostManager:UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,UIDocumentInteractionControllerDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        posts = posts.reversed()
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if posts[indexPath.item].attachmentType != nil &&
            posts[indexPath.item].attachmentType! == .image{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImagePostCell", for: indexPath) as! ImagePostCell
            cell.setupCell(post: posts[indexPath.item])
            return cell
        }
        if posts[indexPath.item].attachmentType != nil &&
            posts[indexPath.item].attachmentType! == .document{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DocumentCell", for: indexPath) as! DocumentPostCell
            cell.setupCell(post: posts[indexPath.item])
            return cell
        }
        if posts[indexPath.item].attachmentType != nil &&
            posts[indexPath.item].attachmentType! == .movie{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VideoCell", for: indexPath) as! VideoPostCell
            cell.setupCell(post: posts[indexPath.item])
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostCell", for: indexPath) as! PostCell
        cell.setupCell(post: posts[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        if posts[indexPath.item].attachmentType != nil &&
            posts[indexPath.item].attachmentType! == .image{
            return CGSize(width: 288, height: 384.5)
        }
        if posts[indexPath.item].attachmentType != nil &&
            posts[indexPath.item].attachmentType! == .document{
            return CGSize(width: 288, height: 204)
        }
        if posts[indexPath.item].attachmentType != nil &&
            posts[indexPath.item].attachmentType! == .movie{
            return CGSize(width: 288, height: 309)
        }
        return CGSize(width: 288, height: 184.5)
    }
    
    //    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    //        if posts[indexPath.item].attachmentType != nil &&
    //            posts[indexPath.item].attachmentType! == .document{
    //            print(posts[indexPath.item])
    //            let url: URL! = URL(string: "http://developer.apple.com/iphone/library/documentation/UIKit/Reference/UIWebView_Class/UIWebView_Class.pdf")
    //            let vc = UIViewController()
    //            vc.view.backgroundColor = .red
    //            let webView = WKWebView()
    //            vc.view.addSubview(webView)
    //            webView.load(URLRequest(url: url))
    //
    ////            let docController = UIDocumentInteractionController(url: URL(string: "www.orimi.com/pdf-test.pdf")!)
    ////            docController.delegate = self
    ////            docController.presentPreview(animated: true)
    //        }
    //    }
    //
    //    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
    //        return HomeVC()
    //    }
    
    
}



