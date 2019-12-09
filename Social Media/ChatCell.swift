//
//  ChatCell.swift
//  Social Media
//
//  Created by Mostafa Elshazly on 11/30/19.
//  Copyright © 2019 Mostafa Elshazly. All rights reserved.
//

import UIKit

class ChatCell:UICollectionViewCell{
    @IBOutlet weak var chatImage: UIImageView!
    @IBOutlet weak var chatTextView: UITextView!
    
    func setupCell(with message:Message){
        chatTextView.text = message.messageBody
        ImageProcessor.retrieveImage(for: message.sender, imageView: chatImage)
        
    }
}
