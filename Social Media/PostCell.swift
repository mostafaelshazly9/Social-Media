//
//  PostCell.swift
//  Social Media
//
//  Created by Mostafa Elshazly on 10/17/19.
//  Copyright © 2019 Mostafa Elshazly. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage

class PostCell:UICollectionViewCell,LikeableCell{
    var postID = ""
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var user: UILabel!
    @IBOutlet weak var post: UITextView!
    @IBOutlet weak var likes: UILabel!
    @IBAction func commentsPressed(_ sender: UIButton) {
        let vc = CommentsVC()
        vc.postID = postID
        vc.setup()
        print(postID)
        parentViewController?.navigationController?.pushViewController(vc, animated: true)
    }
    @IBOutlet weak var date: UILabel!

    @IBAction func likeButtonPressed(_ sender: UIButton) {
        LikeManager.like(target: postID, likeableCell: self)
    }
    @IBOutlet weak var likeButton: UIButton!
    let ref = Database.database().reference(withPath: "posts")
    let storage = Storage.storage()
    lazy var storageRef = storage.reference()

    func setupCell(post:Post) {
        setupCell(postID:post.id!, poster:post.poster, postDate:post.date, postText:post.post, likers:post.likers ?? [String](), comments:post.comments ?? [Comment]())
    }
    func setupCell(postID:String, poster:String, postDate:Double, postText:String, likers:[String], comments:[Comment]) {
        layer.borderWidth = 1
        layer.borderColor = UIColor.gray.cgColor
        let imgRef = storageRef.child("profileImages/\(poster).jpg")
        imgRef.getData(maxSize: 10 * 1024 * 1024) { (data, error) in
              if let error = error {
                print("Error found! :\(error.localizedDescription)")
            } else {
                self.posterImage.image = UIImage(data: data!)
            }
        }
        self.postID = postID
        user.text = poster
        post.text = postText
        likes.text = "Likes: \(likers.count)"
        date.text = PostCell.getDateString(timeIntervalSince1970: postDate)
    }
    
    func updateCell(likers:[String]){
        if likers.contains((Auth.auth().currentUser?.email)!){
            likeButton.backgroundColor = .green
        }else{
            likeButton.backgroundColor = .white
        }
        likes.text = "Likes: \(likers.count)"
    }
    
    class func getDateString(timeIntervalSince1970:Double)->String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        dateFormatter.timeZone = .current
        return dateFormatter.string(from: Date(timeIntervalSince1970: timeIntervalSince1970 / 1000))
    }
    
}
