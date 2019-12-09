//
//  MessageManager.swift
//  Social Media
//
//  Created by Mostafa Elshazly on 11/30/19.
//  Copyright © 2019 Mostafa Elshazly. All rights reserved.
//


import Foundation
import Firebase
import FirebaseDatabase
let messageRef = Database.database().reference(withPath: "messages")

class MessageManager:NSObject{
    class func sendMessage(to receiver:String, messageBody:String){
        guard let sender = Auth.auth().currentUser?.email else { return }
        let uuid = UUID().uuidString
        let dict = [
            "id": uuid,
            "sender": sender,
            "receiver":receiver,
            "messageBody":messageBody,
            "date": ServerValue.timestamp(),
            ] as [String : Any]
        messageRef.child("\(Date())---\(uuid)").setValue(dict)
    }
    
    class func getMessagesBetween(_ otherPerson:String, completion: @escaping (_ messages:[Message],_ error:MessagesError?)->Void){
        messageRef.observe(.value, with: { snapshot in
            if snapshot.exists() == false { return }
            guard let userEmail = Auth.auth().currentUser?.email else { return }
            var newMessages = [Message]()
            for child in snapshot.children{
                let message = (child as! DataSnapshot).value  as! [String: Any]
                if  ((message["sender"] as! String  == otherPerson) &&
                    (message["receiver"] as! String == userEmail)) ||
                    ((message["sender"] as! String  == userEmail) &&
                    (message["receiver"] as! String == otherPerson))
                    
                {
                    let newMessage = Message(id: message["id"] as! String,
                                             sender: message["sender"] as! String,
                                             receiver: message["receiver"] as! String,
                                             messageBody: message["messageBody"] as! String,
                                             date: Double(truncating: message["date"] as! NSNumber))
                    newMessages.append(newMessage)
                }
            }
            var error:MessagesError?
            if newMessages.isEmpty{
                error = MessagesError.noMessages
            }
            completion(newMessages.reversed(), error)
        })
        
    }
        
}
