//
//  RepliesVC.swift
//  Social Media
//
//  Created by Mostafa Elshazly on 11/4/19.
//  Copyright © 2019 Mostafa Elshazly. All rights reserved.
//

import UIKit

class RepliesVC:CommentsVC{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        (view as! ReplyContainerView).postID = postID
    }
    
    override func loadView() {
        view = ReplyContainerView()
        (view as! ReplyContainerView).setup()
    }
    override func setup(){
        ReplyManager.shared.loadComments(for: postID, VC: self)
    }
    
}
