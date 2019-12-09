//
//  ImagePostCell.swift
//  Social Media
//
//  Created by Mostafa Elshazly on 11/16/19.
//  Copyright © 2019 Mostafa Elshazly. All rights reserved.
//

import UIKit

class ImagePostCell:PostCell{
    @IBOutlet weak var postImage: UIImageView!
    
    override func setupCell(post: Post) {
        super.setupCell(post: post)
        if (post.attachmentType != nil) {
            PostManager.instance.retrieveFile(for: post.id!, of: post.attachmentType!, imageView: postImage, fileButton: nil, videoView: nil, completion: nil)
        }
    }
    
}
