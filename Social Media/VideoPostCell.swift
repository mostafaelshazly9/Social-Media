//
//  VideoPostCell.swift
//  Social Media
//
//  Created by Mostafa Elshazly on 12/9/19.
//  Copyright © 2019 Mostafa Elshazly. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class VideoPostCell:PostCell{

    @IBOutlet weak var videoView: UIView!
    var url:URL?
    override func setupCell(post: Post) {
        super.setupCell(post: post)
        if (post.attachmentType != nil) {
            PostManager.instance.retrieveFile(for: postID, of: .movie, imageView: nil, fileButton: nil, videoView: videoView) {
                self.url = $0
            }
        }
        let tap = UITapGestureRecognizer(target: self, action: #selector(videoViewTapped))
        videoView.addGestureRecognizer(tap)
    }
    
    @objc func videoViewTapped(){
        let player = AVPlayer(url: url!)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        if let topController = UIApplication.topViewController() {
            topController.navigationController?.pushViewController(playerViewController, animated: true)
                playerViewController.player!.play()
        }
    }
    
    
    
}
