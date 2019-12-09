//
//  FriendCell.swift
//  Social Media
//
//  Created by Mostafa Elshazly on 11/14/19.
//  Copyright © 2019 Mostafa Elshazly. All rights reserved.
//

import UIKit

class FriendCell:UITableViewCell{
    
    @IBOutlet weak var user: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    
    func setup(friend:String){
        user.text = friend
        ImageProcessor.retrieveImage(for: friend, imageView: userImage)
    }
}
