//
//  PeopleVC.swift
//  Social Media
//
//  Created by Mostafa Elshazly on 10/19/19.
//  Copyright © 2019 Mostafa Elshazly. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
class PeopleVC:UIViewController{
    
    let ref = Database.database().reference(withPath: "users")
    var users = [String]()
    @IBOutlet weak var peopleCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        peopleCollectionView.delegate = self
        peopleCollectionView.dataSource = self

        ref.observe(.value, with: { snapshot in
            if snapshot.exists() == false {return}
            
            for child in snapshot.children{
                let user = (child as! DataSnapshot).value  as! [String: Any]
                if (user["user"] == nil || user["user"] as? String == Auth.auth().currentUser?.email) { continue }
                let email = user["user"] as! String
                self.users.append(email)
                self.peopleCollectionView.reloadData()
            }
        })
    }
}

extension PeopleVC:UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return users.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PersonCell", for: indexPath) as! PeopleCell
        cell.setupCell(user: users[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "OtherUserProfile") as? OtherUserProfile {
            navigationController?.pushViewController(vc, animated: true)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                vc.setup(user:self.users[indexPath.item])
            }
        }
    }
}
