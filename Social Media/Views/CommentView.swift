//
//  CommentView.swift
//  Social Media
//
//  Created by Mostafa Elshazly on 11/3/19.
//  Copyright © 2019 Mostafa Elshazly. All rights reserved.
//

import UIKit
import FirebaseAuth

class CommentView:UICollectionViewCell,LikeableCell{
    
    let profileImage = UIImageView()
    let nameLabel = UILabel()
    let dateLabel = UILabel()
    let postTextBox = UITextView()
    let likeButton = UIButton()
    let likeCount = UILabel()
    let replyButton = UIButton()
    let modifyButton = UIButton()
    let deleteButton = UIButton()
    var id = ""
    var postID = ""
    
    func setup(){
//        translatesAutoresizingMaskIntoConstraints = false
        setupImage()
        setupNameLabel()
        setupDateLabel()
        setupPostTextBox()
        setupLikeButton()
        setupReplyButton()
        setupLikeCount()
        setupDeleteButton()
        setupModifyButton()
        layer.borderWidth = 1
        layer.borderColor = UIColor.gray.cgColor

    }
    
    func fill(parentID:String, id:String, name:String,date:Double,comment:String, likes:Int){
        postID = parentID
        self.id = id
        ImageProcessor.retrieveImage(for: name, imageView: profileImage)
        nameLabel.text = name
        dateLabel.text = PostCell.getDateString(timeIntervalSince1970: date)
        postTextBox.text = comment
        likeCount.text = "Likes: \(likes)"
        
        if Auth.auth().currentUser?.email != nameLabel.text{
            modifyButton.isHidden = true
            deleteButton.isHidden = true
        }

    }
    
    func setupImage(){
        profileImage.contentMode = .scaleAspectFit
        addSubview(profileImage)
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        profileImage.widthAnchor.constraint(equalToConstant: 35).isActive = true
        profileImage.heightAnchor.constraint(equalToConstant: 35).isActive = true
        profileImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8).isActive = true
        profileImage.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        
    }
    
    func setupNameLabel(){
        nameLabel.font = .preferredFont(forTextStyle: .subheadline)
        addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.leadingAnchor.constraint(equalTo: profileImage.trailingAnchor, constant: 8).isActive = true
        nameLabel.centerYAnchor.constraint(equalTo: profileImage.centerYAnchor).isActive = true
    }
    
    func setupDateLabel(){
        dateLabel.textColor = .lightGray
        dateLabel.font = .preferredFont(forTextStyle: .footnote)
        addSubview(dateLabel)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8).isActive = true
        dateLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4).isActive = true
    }
    
    func setupPostTextBox(){
        postTextBox.isEditable = false
        addSubview(postTextBox)
        postTextBox.translatesAutoresizingMaskIntoConstraints = false
        postTextBox.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        postTextBox.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 4).isActive = true
        postTextBox.heightAnchor.constraint(equalToConstant: 75).isActive = true
        postTextBox.widthAnchor.constraint(equalTo: widthAnchor, constant:  -4).isActive = true

    }
    
    func setupLikeButton(){
        likeButton.setTitle("Like", for: .normal)
        likeButton.setTitleColor(.systemBlue, for: .normal)
        addSubview(likeButton)
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        likeButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8).isActive = true
        likeButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
        likeButton.addTarget(self, action: #selector(like), for: .touchUpInside)
    }

    func setupReplyButton(){
        replyButton.setTitle("Replies", for: .normal)
        replyButton.setTitleColor(.systemBlue, for: .normal)
        addSubview(replyButton)
        replyButton.translatesAutoresizingMaskIntoConstraints = false
        replyButton.leadingAnchor.constraint(equalTo: likeButton.trailingAnchor, constant: 8).isActive = true
        replyButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
        replyButton.addTarget(self, action: #selector(reply), for: .touchUpInside)
    }
    
    func setupLikeCount(){
        addSubview(likeCount)
        likeCount.translatesAutoresizingMaskIntoConstraints = false
        likeCount.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        likeCount.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12).isActive = true
    }
    
    
    func setupModifyButton(){
        modifyButton.setTitle("Edit", for: .normal)
        modifyButton.setTitleColor(.systemBlue, for: .normal)
        addSubview(modifyButton)
        modifyButton.translatesAutoresizingMaskIntoConstraints = false
        modifyButton.trailingAnchor.constraint(equalTo: deleteButton.leadingAnchor, constant: -8).isActive = true
        modifyButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
        modifyButton.addTarget(self, action: #selector(modify), for: .touchUpInside)
    }

    
    func setupDeleteButton(){
        deleteButton.setTitle("Delete", for: .normal)
        deleteButton.setTitleColor(.systemBlue, for: .normal)
        addSubview(deleteButton)
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8).isActive = true
        deleteButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
        deleteButton.addTarget(self, action: #selector(deleteComment), for: .touchUpInside)
    }
    
    func updateCell(likers:[String]){
        if likers.contains((Auth.auth().currentUser?.email)!){
            likeButton.backgroundColor = .green
        }else{
            likeButton.backgroundColor = .white
        }
        likeCount.text = "Likes: \(likers.count)"
    }



    @objc func like(){
        LikeManager.like(target: id, likeableCell: self)
    }
    
    @objc func reply(){
        let vc = RepliesVC()
        vc.postID = id
        vc.setup()
        parentViewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func modify(){
        CommentManager.shared.editComment(id, VC: parentViewController!)
    }


    @objc func deleteComment(){
        CommentManager.shared.deleteComment(id, VC: parentViewController!)
    }

}
