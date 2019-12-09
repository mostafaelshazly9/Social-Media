//
//  FriendRequestsTableVC.swift
//  Social Media
//
//  Created by Mostafa Elshazly on 11/11/19.
//  Copyright © 2019 Mostafa Elshazly. All rights reserved.
//

import UIKit

class FriendRequestsTableVC:UITableViewController{
    var requests = [Request]()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        FriendManager.getFriendRequests(in: self)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return requests.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RequestCell", for: indexPath) as! RequestCell
        cell.setup(for: requests[indexPath.row])
        return cell
    }
}
