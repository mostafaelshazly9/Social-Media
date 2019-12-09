//
//  Post.swift
//  Social Media
//
//  Created by Mostafa Elshazly on 10/17/19.
//  Copyright © 2019 Mostafa Elshazly. All rights reserved.
//

import Foundation

class Post{
    var id:String?
    var poster: String
    var date = Double(0)
    var post = ""
    var likers:[String]?
    var likeCount:Int? {
        return likers?.count
    }
    var comments:[Comment]?
    var attachmentType:PostType?
    var attachmentInfo:[String:String]!

    init(id:String?, poster:String, date:Double, post:String, likers:[String]?, comments:[Comment]?, type:PostType? = nil,typeRawValue:String?,attachmentInfo:[String:String]) {
        self.id = id
        self.poster = poster
        self.date = date
        self.post = post
        self.likers = likers
        self.comments = comments
        if type != nil{
            self.attachmentType = type
            self.attachmentInfo = attachmentInfo
        }else if typeRawValue != nil{
            self.attachmentType = PostType(rawValue: typeRawValue!)
        }
        }
    

}
