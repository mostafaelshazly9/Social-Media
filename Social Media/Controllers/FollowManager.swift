//
//  FollowManager.swift
//  Social Media
//
//  Created by Mostafa Elshazly on 10/26/19.
//  Copyright © 2019 Mostafa Elshazly. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase
let followRef = Database.database().reference(withPath: "follows")

class FollowManager:NSObject{
    class func follow(target:String){
        let uuid = UUID().uuidString
        guard let userEmail = Auth.auth().currentUser?.email else { return }
        let dict = [
            "id": uuid,
            "user": userEmail,
            "following": target,
            ] as [String : Any]
        followRef.child(uuid).setValue(dict)
    }
    
    class func follow(follower:String, target:String){
        let uuid = UUID().uuidString
        let dict = [
            "id": uuid,
            "user": follower,
            "following": target,
            ] as [String : Any]
        followRef.child(uuid).setValue(dict)
    }

}
