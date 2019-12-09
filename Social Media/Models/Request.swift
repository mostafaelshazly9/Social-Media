//
//  Request.swift
//  Social Media
//
//  Created by Mostafa Elshazly on 11/11/19.
//  Copyright © 2019 Mostafa Elshazly. All rights reserved.
//

import Foundation

class Request{

    var id = ""
    var user = ""
    var target = ""
    var state = ""
        
    init(id:String, user:String, target:String, state:String) {
        self.id = id
        self.user = user
        self.target = target
        self.state = state
    }
}
