//
//  RequestCell.swift
//  Social Media
//
//  Created by Mostafa Elshazly on 11/12/19.
//  Copyright © 2019 Mostafa Elshazly. All rights reserved.
//

import UIKit

class RequestCell:UITableViewCell{
    @IBOutlet weak var userLabel: UILabel!
    @IBAction func acceptButtonPressed(_ sender: UIButton) {
        guard let user = userLabel.text else { return }
        FriendManager.acceptFriendRequest(from: user, in: (parentViewController as! FriendRequestsTableVC))
    }
    @IBAction func rejectButtonPressed(_ sender: UIButton) {
        guard let user = userLabel.text else { return }
        FriendManager.rejectFriendRequest(from: user, in: (parentViewController as! FriendRequestsTableVC))
    }
    var id = ""
    func setup(for request:Request){
        userLabel.text = request.user
        id = request.id
    }
}
