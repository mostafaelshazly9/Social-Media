//
//  Message.swift
//  Social Media
//
//  Created by Mostafa Elshazly on 11/30/19.
//  Copyright © 2019 Mostafa Elshazly. All rights reserved.
//

import Foundation

class Message{

    var id = ""
    var sender = ""
    var receiver = ""
    var messageBody = ""
    var date = Double(0)

    init(id:String, sender:String, receiver:String, messageBody:String, date:Double) {
        self.id = id
        self.sender = sender
        self.receiver = receiver
        self.messageBody = messageBody
        self.date = date
    }
}
