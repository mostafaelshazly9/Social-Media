//
//  FriendsTableVC.swift
//  Social Media
//
//  Created by Mostafa Elshazly on 11/13/19.
//  Copyright © 2019 Mostafa Elshazly. All rights reserved.
//

import UIKit

class FriendsTableVC:UITableViewController{
    var friends = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        FriendManager.getFriends(in: self)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendCell", for: indexPath) as! FriendCell
        cell.setup(friend: friends[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "OtherUserProfile") as? OtherUserProfile {
            navigationController?.pushViewController(vc, animated: true)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                vc.setup(user:self.friends[indexPath.row])
            }
        }
    }
}
