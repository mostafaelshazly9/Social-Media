//
//  ChatVC.swift
//  Social Media
//
//  Created by Mostafa Elshazly on 11/30/19.
//  Copyright © 2019 Mostafa Elshazly. All rights reserved.
//

import UIKit
import Firebase

class ChatVC:UIViewController{
    private var chatTarget = ""
    private var messages = [Message]()
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBAction func sendButtonPressed(_ sender: UIButton) {
        MessageManager.sendMessage(to: chatTarget, messageBody: messageTextField.text!)
        messageTextField.text = ""
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        collectionView.transform = CGAffineTransform(scaleX: 1, y: -1)
    }
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            MessageManager.getMessagesBetween(self.chatTarget) { (newMessages, error) in
                if error == nil{
                    self.messages = newMessages
                    self.collectionView.reloadData()
                }else{
                    print(error?.localizedDescription)
                }
            }
        }
        
    }
    func setChatTarget(to target:String){
        chatTarget = target
        title = chatTarget
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
}
extension ChatVC:UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        MessageManager.getMessagesBetween(chatTarget) { (newMessages, error) in
            if error == nil{
                self.messages = newMessages
            }else{
                print(error?.localizedDescription)
            }
        }
        return messages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var reuseIdentifier = ""
        if messages[indexPath.item].sender == Auth.auth().currentUser?.email{
            reuseIdentifier = "MyMessage"
        }else{
            reuseIdentifier = "OtherMessage"
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ChatCell
        if reuseIdentifier == "MyMessage"{
            cell.chatTextView.textAlignment = .right
        }
        cell.setupCell(with: messages[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width - 16, height: 50)
    }
    
}
