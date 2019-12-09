//
//  CommentsVC.swift
//  Social Media
//
//  Created by Mostafa Elshazly on 10/26/19.
//  Copyright © 2019 Mostafa Elshazly. All rights reserved.
//

import UIKit


class CommentsVC: UIViewController {
    
    var postID = ""
//    let textReplyManager = TextReplyManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped(_:)))
        view.addGestureRecognizer(tapGesture)
        (view as! CommentsContainerView).postID = postID
//        comment.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    override func loadView() {
        view = CommentsContainerView()
        (view as! CommentsContainerView).setup()
//        (view as! CommentsContainerView).collectionView.register(CommentView.self, forCellWithReuseIdentifier: "collectionCell")
    }
    
    @objc func viewTapped(_ sender: UITapGestureRecognizer? = nil){
        view.endEditing(true)
    }
    
    func setup(){
        CommentManager.shared.loadComments(for: postID, VC: self)
    }
    
    
}
