//
//  DocumentPostCell.swift
//  Social Media
//
//  Created by Mostafa Elshazly on 12/9/19.
//  Copyright © 2019 Mostafa Elshazly. All rights reserved.
//

import UIKit

class DocumentPostCell:PostCell{
    
    @IBOutlet weak var documentButton: UIButton!
    @IBAction func documentButtonPressed(_ sender: UIButton) {
        PostManager.instance.retrieveFile(for: postID, of: .document, imageView: nil, fileButton: sender, videoView: nil, completion: nil)
    }
    
    override func setupCell(post: Post) {
        super.setupCell(post: post)
        documentButton.setTitle(post.attachmentInfo["fileName"], for: .normal)
    }
    
}
