//
//  ChatTableVC.swift
//  Social Media
//
//  Created by Mostafa Elshazly on 11/30/19.
//  Copyright © 2019 Mostafa Elshazly. All rights reserved.
//

import UIKit

class ChatTableVC:FriendsTableVC{
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
                if let vc = storyboard?.instantiateViewController(withIdentifier: "ChatVC") as? ChatVC {
            navigationController?.pushViewController(vc, animated: true)
                vc.setChatTarget(to: self.friends[indexPath.row])
        }
    }
}
