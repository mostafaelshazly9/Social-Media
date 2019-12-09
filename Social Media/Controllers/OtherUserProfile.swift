//
//  OtherUserProfile.swift
//  Social Media
//
//  Created by Mostafa Elshazly on 10/20/19.
//  Copyright © 2019 Mostafa Elshazly. All rights reserved.
//

import UIKit

class OtherUserProfile:UIViewController{

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userLabel: UILabel!
    @IBAction func followButtonPressed(_ sender: UIButton) {
        FollowManager.follow(target: user)
        AlertManager.showAlert(title: "Success", message: "User Followed", target: self)
    }
    @IBAction func addFriendButtonPressed(_ sender: UIButton) {
        guard let user = userLabel.text else { return }
        FriendManager.addFriend(target: user)
    }
    @IBOutlet weak var postsCollectionView: UICollectionView!
    let postManager = PostManager.instance
    var user = ""
    
    func setup(user:String){
        self.user = user
        postManager.setFollowers([user])
        postManager.loadPosts(postsCollectionView: postsCollectionView)
        title = user
        userLabel.text = user
        ImageProcessor.retrieveImage(for: user, imageView: profileImage)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped(_:)))
        view.addGestureRecognizer(tapGesture)
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
    
}

