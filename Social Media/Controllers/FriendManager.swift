//
//  FriendManager.swift
//  Social Media
//
//  Created by Mostafa Elshazly on 11/8/19.
//  Copyright © 2019 Mostafa Elshazly. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase
let friendRef = Database.database().reference(withPath: "friends")

class FriendManager:NSObject{
    
    class func addFriend(target:String){
        
        friendRef.observeSingleEvent(of:  .value, with: { snapshot in
            if snapshot.exists() == false {return}
            for child in snapshot.children{
                let request = (child as! DataSnapshot).value  as! [String: Any]
                guard let userEmail = Auth.auth().currentUser?.email else { return }
                if request["user"] as! String == userEmail &&
                    request["target"] as! String == target &&
                    request["state"] as! String == "request"{
                    friendRef.child((child as! DataSnapshot).key).removeValue()
                    return
                }
                }
            let uuid = UUID().uuidString
            guard let userEmail = Auth.auth().currentUser?.email else { return }
            let dict = [
                "id": uuid,
                "user": userEmail,
                "target": target,
                "state": "request"
                ] as [String : Any]
            friendRef.child(uuid).setValue(dict)
            })
}
    
//    class func cancelFriendRequest(target:String){
//        friendRef.observeSingleEvent(of: .value, with: { snapshot in
//            if snapshot.exists() == false {return}
//            for child in snapshot.children{
//
//                let request = (child as! DataSnapshot).value  as! [String: Any]
//                guard let userEmail = Auth.auth().currentUser?.email else { return }
//                if request["user"] as! String == userEmail &&
//                    request["target"] as! String == target &&
//                    request["state"] as! String == "request"{
//                    friendRef.child((child as! DataSnapshot).key).removeValue()
//                    }
//                }
//        })
//    }


    class func acceptFriendRequest(from user:String, in VC:FriendRequestsTableVC){
        friendRef.observeSingleEvent(of:  .value, with: { snapshot in
            if snapshot.exists() == false {return}
            for child in snapshot.children{
                let request = (child as! DataSnapshot).value  as! [String: Any]
                guard let userEmail = Auth.auth().currentUser?.email else { return }
                if request["user"] as! String == user &&
                    request["target"] as! String == userEmail &&
                    request["state"] as! String == "request"{
                    let dict = [
                        "id": request["id"] as! String,
                        "user": user,
                        "target": userEmail,
                        "state": "friend"
                        ] as [String : Any]
                    friendRef.child(request["id"] as! String).setValue(dict)
                    FollowManager.follow(target: user)
                    FollowManager.follow(follower: user, target: userEmail)
                    }
                }
            getFriendRequests(in: VC)
        })
    }
    

    class func rejectFriendRequest(from user:String, in VC:FriendRequestsTableVC){
        friendRef.observeSingleEvent(of: .value, with: { snapshot in
            if snapshot.exists() == false {return}
            for child in snapshot.children{
                
                let request = (child as! DataSnapshot).value  as! [String: Any]
                guard let userEmail = Auth.auth().currentUser?.email else { return }
                if request["user"] as! String == user &&
                    request["target"] as! String == userEmail &&
                    request["state"] as! String == "request"{
                    friendRef.child((child as! DataSnapshot).key).removeValue()
                    }
                }
            getFriendRequests(in: VC)
        })
    }

    
    class func getFriends(in VC:FriendsTableVC){
        friendRef.observe(  .value, with: { snapshot in
            var friends = [String]()
            if snapshot.exists() == false {return}
            for child in snapshot.children{
                let request = (child as! DataSnapshot).value  as! [String: Any]
                guard let userEmail = Auth.auth().currentUser?.email else { return }
                if  (request["user"] as! String == userEmail ||
                    request["target"] as! String == userEmail) &&
                    request["state"] as! String == "friend"{
                    if request["user"] as! String == userEmail{
                        friends.append(request["target"] as! String)
                    }else{
                        friends.append(request["user"] as! String)
                    }
                }
                }
            VC.friends = friends
            VC.tableView.reloadData()
        })
    }
    
    class func getFriendRequests(in VC:FriendRequestsTableVC){
        friendRef.observe(  .value, with: { snapshot in
            var requests = [Request]()
            if snapshot.exists() == false {return}
            for child in snapshot.children{
                let request = (child as! DataSnapshot).value  as! [String: Any]
                guard let userEmail = Auth.auth().currentUser?.email else { return }
                if  request["target"] as! String == userEmail &&
                    request["state"] as! String == "request"{
                    requests.append(Request(
                        id: request["id"] as! String,
                        user: request["user"] as! String,
                        target: request["target"] as! String,
                        state: request["state"] as! String
                    ))
                    }
                }
            VC.requests = requests
            VC.tableView.reloadData()
        })
    }


}

//extension FriendManager:UITableViewDataSource, UITableViewDelegate{
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        <#code#>
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        <#code#>
//    }
//
//
//}
