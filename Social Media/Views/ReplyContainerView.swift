//
//  ReplyContainerView.swift
//  Social Media
//
//  Created by Mostafa Elshazly on 11/4/19.
//  Copyright © 2019 Mostafa Elshazly. All rights reserved.
//

import UIKit

class ReplyContainerView:CommentsContainerView{
    override func setup() {
        super.setup()
        commentButton.setTitle("Reply", for: .normal)
        collectionView.register(ReplyView.self, forCellWithReuseIdentifier: "ReplyCell")
        collectionView.dataSource = ReplyManager.shared
        collectionView.delegate = ReplyManager.shared
    }
    
    @objc override func postComment(){
        ReplyManager.shared.addComment(comment: commentTextField.text!, parentID: postID, commentsContainer: self)
    }

}
