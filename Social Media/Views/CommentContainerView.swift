//
//  CommentContainerView.swift
//  Social Media
//
//  Created by Mostafa Elshazly on 11/3/19.
//  Copyright © 2019 Mostafa Elshazly. All rights reserved.
//

import UIKit

class CommentsContainerView:UIView{
    var postID = ""
//    let scrollView = UIScrollView()
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    let commentTextField = UITextField()
    let commentButton = UIButton()
//    let textReplyManager = TextReplyManager()

    func setup(){
        backgroundColor = .white
        let view = (parentViewController?.view.safeAreaLayoutGuide)!
//        translatesAutoresizingMaskIntoConstraints = false
        leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8).isActive = true
        trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8).isActive = true
        topAnchor.constraint(equalTo: view.topAnchor, constant: 8).isActive = true
        bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -8).isActive = true

        addSubview(commentButton)
        commentButton.setTitle("Comment", for: .normal)
        commentButton.translatesAutoresizingMaskIntoConstraints = false
        commentButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8).isActive = true
        commentButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 8).isActive = true
        commentButton.setTitleColor(.systemBlue, for: .normal)
        commentButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        commentButton.addTarget(self, action: #selector(postComment), for: .touchUpInside)
        
        addSubview(commentTextField)
        commentTextField.translatesAutoresizingMaskIntoConstraints = false
        commentTextField.trailingAnchor.constraint(equalTo: commentButton.leadingAnchor, constant: -8).isActive = true
        commentTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8).isActive = true
        commentTextField.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 8).isActive = true
        commentTextField.heightAnchor.constraint(equalToConstant: 25).isActive = true
        commentTextField.backgroundColor = .lightGray

        
        addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8).isActive = true
        collectionView.topAnchor.constraint(equalTo: commentTextField.bottomAnchor, constant: 8).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
        collectionView.register(CommentView.self, forCellWithReuseIdentifier: "CommentCell")
        collectionView.backgroundColor = .white
        collectionView.dataSource = CommentManager.shared
        collectionView.delegate = CommentManager.shared
//        collectionView.bounces = true
//        collectionView.alwaysBounceVertical = true
        

        
//        scrollView.heightAnchor.constraint(equalTo: heightAnchor, constant: -80).isActive = true
//        scrollView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
//        scrollView.contentSize.height = 1000

        

        

    }
    
    @objc func postComment(){
        CommentManager.shared.addComment(comment: commentTextField.text!, parentID: postID, commentsContainer: self)
    }
    
}


