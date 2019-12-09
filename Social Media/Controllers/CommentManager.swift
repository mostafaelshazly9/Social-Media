//
//  TextReplyManager.swift
//  Social Media
//
//  Created by Mostafa Elshazly on 10/27/19.
//  Copyright © 2019 Mostafa Elshazly. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

class CommentManager: NSObject {
    
    static let shared = CommentManager()
    
    let ref = Database.database().reference(withPath: "comments")
    var comments = [Comment]()
    var postID = ""
    
    internal override init()
    {
        
    }

    func addComment(comment:String, parentID:String, commentsContainer:CommentsContainerView){
        let uuid = UUID().uuidString
        guard comment.count > 0, let userEmail = Auth.auth().currentUser?.email else { return }
        let dict = [
            "id" : uuid,
            "parentID" : parentID,
            "poster" : userEmail,
            "text" : comment,
            "date" : ServerValue.timestamp(),
            "replies" : [String](),
            "likers": [String]()
            ] as [String : Any]
        ref.child("\(Date())---\(uuid)").setValue(dict)
        notifySuccess(commentsContainer: commentsContainer)
        commentsContainer.commentTextField.text = ""
        loadComments(for: parentID, VC: commentsContainer.parentViewController as! CommentsVC)
        commentsContainer.endEditing(true)
    }
    
    func notifySuccess(commentsContainer:CommentsContainerView){
        AlertManager.showAlert(title: "Success", message: "Comment posted", target: commentsContainer.parentViewController!)
    }

    
    func loadComments(for postID:String, VC:CommentsVC){
        self.postID = postID
        ref.observe( .value, with: { snapshot in
            if snapshot.exists() == false {
                (VC.view as! CommentsContainerView).collectionView.reloadData()
                return
            }
            var newComments = [Comment]()
            for child in snapshot.children{
                let comment = (child as! DataSnapshot).value  as! [String: Any]
                if  comment["parentID"] as! String == postID {
                    let newComment = Comment(id: comment["id"] as! String,
                                             postID: comment["parentID"] as! String,
                                             poster: comment["poster"] as! String,
                                             date: Double(truncating: comment["date"] as! NSNumber),
                                             text: comment["text"] as! String,
                                             replies: comment["replies"] as? [String] ?? [String](),
                                             likers: comment["likers"] as? [String] ?? [String]())
                    newComments.append(newComment)
                }
            }
            self.comments = newComments
            (VC.view as! CommentsContainerView).collectionView.reloadData()
//            self.renderComments(VC:VC, comments: newComments)
        })
    }
    
    
    func deleteComment(_ commentID:String, VC:UIViewController){
        ref.observeSingleEvent(of: .value, with: { snapshot in
            for child in snapshot.children {
                if (child as! DataSnapshot).key.contains(commentID){
                    self.ref.child((child as! DataSnapshot).key).removeValue { error,_  in
                      if error != nil {
                        AlertManager.showAlert(title: "Error", message: "error \(error!.localizedDescription)", target: VC)
                      }else{
                        AlertManager.showAlert(title: "Success", message: "Comment deleted successfully", target: VC)
                        }
                        self.loadComments(for: self.postID, VC: VC as! CommentsVC)
                    }

                
            }
        }
        })
    }
    
        func editComment(_ commentID:String, VC:UIViewController){
            let alert = UIAlertController(title: "Edit", message: "New title", preferredStyle: .alert)
            alert.addTextField(configurationHandler: nil)
            let action = UIAlertAction(title: "Done", style: .default) { (UIAlertAction) in
                self.ref.observeSingleEvent(of:  .value, with: { snapshot in
                    for child in snapshot.children {
                        let comment = (child as! DataSnapshot).value  as! [String: Any]
                        if (child as! DataSnapshot).key.contains(commentID){
                            
                            let newComment = [
                                "id" : comment["id"] as! String,
                                "parentID" : comment["parentID"] as! String,
                                "poster" : comment["poster"] as! String,
                                "text" : alert.textFields![0].text!,
                                "date" : Double(truncating: comment["date"] as! NSNumber),
                                "replies" : comment["replies"] as? [String] ?? [String](),
                                "likers": comment["likers"] as? [String] ?? [String]()
                                ] as [String : Any]
                            (self.ref.child((child as! DataSnapshot).key)).setValue(newComment)
                            self.loadComments(for: self.postID, VC: VC as! CommentsVC)
                        }
                    }
                })
            }
            let action2 = UIAlertAction(title: "Cancel", style: .cancel)
            [action, action2].forEach{ alert.addAction($0) }
            VC.present(alert, animated: true)

        }

}


extension CommentManager:UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return comments.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CommentCell", for: indexPath) as! CommentView
        cell.setup()
        cell.fill(parentID:comments[indexPath.row].parentID, id: comments[indexPath.row].id, name: comments[indexPath.row].poster, date: comments[indexPath.row].date, comment: comments[indexPath.row].text, likes: comments[indexPath.row].likers.count)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width - 16, height: 175)
    }
    
    
}
