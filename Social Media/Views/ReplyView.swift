//
//  ReplyView.swift
//  Social Media
//
//  Created by Mostafa Elshazly on 11/8/19.
//  Copyright © 2019 Mostafa Elshazly. All rights reserved.
//


import UIKit
import FirebaseAuth

class ReplyView:CommentView{
    
    override func setup() {
        super.setup()
//        modifyButton.addTarget(self, action: #selector(modify), for: .touchUpInside)
//        deleteButton.addTarget(self, action: #selector(deleteComment), for: .touchUpInside)
        replyButton.isHidden = true
        likeCount.isHidden = true
        likeButton.isHidden = true
    }
    

    
    @objc override func modify(){
        ReplyManager.shared.editComment(id, VC: parentViewController!)
    }


    @objc override func deleteComment(){
        ReplyManager.shared.deleteComment(id, VC: parentViewController!)
    }

}
