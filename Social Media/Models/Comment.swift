//
//  Comment.swift
//  Social Media
//
//  Created by Mostafa Elshazly on 10/17/19.
//  Copyright © 2019 Mostafa Elshazly. All rights reserved.
//

import Foundation

class Comment:TextReply{
    var id = ""
    var parentID = ""
    var poster:String
    var text = ""
    var date = Double(0)
    var replies = [String]()
    var likers = [String]()
    init(id:String, postID:String, poster:String, date:Double, text:String, replies:[String], likers:[String]) {
        self.id = id
        self.parentID = postID
        self.poster = poster
        self.date = date
        self.text = text
        self.replies = replies
        self.likers = likers
    }

}
