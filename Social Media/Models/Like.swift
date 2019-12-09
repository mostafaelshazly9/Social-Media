//
//  Like.swift
//  Social Media
//
//  Created by Mostafa Elshazly on 10/17/19.
//  Copyright © 2019 Mostafa Elshazly. All rights reserved.
//

import Foundation

class Like{
    var id = ""
    var target = ""
    var likers = [String]()
    
    init(id:String, target:String,likers:[String]) {
        self.id = id
        self.target = target
        self.likers = likers
    }
}
