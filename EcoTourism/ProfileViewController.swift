//
//  ProfileViewController.swift
//  EcoTourism
//
//  Created by Akash  Veerappan on 11/18/18.
//  Copyright © 2018 Akash Veerappan. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class ProfileViewController: UIViewController {

    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    
    var user: User = User()
    
    var currentUserUID: String = ""
    var auth: Auth = Auth.auth()
    var databaseReference: DatabaseReference = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        profileView.layer.cornerRadius = 10
        
        currentUserUID = (auth.currentUser?.uid) ?? ""
        
        if currentUserUID.count > 1 {
            databaseReference = databaseReference.child(currentUserUID)
        }
        
        performProfileDataTransaction()
        
    }
    
    func performProfileDataTransaction() {
        databaseReference.observe(.value) { (snapshot) in
            if let dict = snapshot.value as? [String: Any?] {
                self.user.email = dict["Email"] as? String ?? ""
                self.user.name = dict["Name"] as? String ?? ""
                self.user.dob = dict["DOB"] as? String ?? ""
                self.user.phone = dict["Phone"] as? String ?? ""
                
                self.nameLabel.text = self.user.name
                self.emailLabel.text = self.user.email
                self.ageLabel.text = self.user.dob
                self.phoneLabel.text = self.user.phone
            }
        }
    }

}
