//
//  LikeManager.swift
//  Social Media
//
//  Created by Mostafa Elshazly on 11/3/19.
//  Copyright © 2019 Mostafa Elshazly. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

let likeRef = Database.database().reference(withPath: "likes")

class LikeManager:NSObject{
    
    let shared = LikeManager()
    
    private override init() {}
    
    var likes = [Like]()
    class func like(target:String, likeableCell:LikeableCell){
//        let uuid = UUID().uuidString
        guard let userEmail = Auth.auth().currentUser?.email else { return }
        //Load previous likes:
        likeRef.observeSingleEvent(of : .value, with: { snapshot in
            if snapshot.exists() == false {
                let dict = [
                    "target": target,
                    "likers": userEmail,
                    ] as [String : Any]
                likeRef.child(target).setValue(dict)
                return
                
            }
            for child in snapshot.children{
                let like = (child as! DataSnapshot).value  as! [String: Any]
                var likers = like["likers"] as? [String] ?? [String]()
//                if likers.contains(userEmail){
                if let index = likers.firstIndex(of: userEmail) {
                    likers.remove(at: index)
//                    }
                }else{
                    likers.append(userEmail)
                }
                if like["target"] as! String == target{
                    let dict = [
//                        "id": like["id"] as! String,
                        "target": like["target"] as! String,
                        "likers": likers,
                        ] as [String : Any]
//                    likeRef.child(like["id"] as! String).setValue(dict)
                    likeRef.child(like["target"] as! String).setValue(dict)
                    likeableCell.updateCell(likers: likers)
                    return
                }else{
                    let dict = [
                        "target": target,
                        "likers": userEmail,
                        ] as [String : Any]
                    likeRef.child(target).setValue(dict)
                    likeableCell.updateCell(likers: likers)
                }
            }
        })
        
    }
    
//    func loadLikes(for target:String){
//        likeRef.observeSingleEvent(of: .value, with: { snapshot in
//            if snapshot.exists() == false {return}
//            for child in snapshot.children{
//
//                let like = (child as! DataSnapshot).value  as! [String: Any]
//                    let newLike = Like(id: like["id"] as! String,
//                                       target: like["target"] as! String,
//                                       likers: like["likers"] as? [String] ?? [String]())
//                self.likes.append(newLike)
//            }
//        })
//    }

}
