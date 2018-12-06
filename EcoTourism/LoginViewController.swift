//
//  LoginViewController.swift
//  EcoTourism
//
//  Created by Akash  Veerappan on 11/16/18.
//  Copyright © 2018 Akash Veerappan. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var pwdField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    var email: String = ""
    var pwd: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.layer.cornerRadius = 10
    }
    
    @IBAction func onLoginClicked(_ sender: UIButton) {
        
        var validEmail: Bool = false
        var validPwd: Bool = false
        
        if (emailField.text != nil) {
            if (emailField.text?.count ?? 0 > 6) {
                if (emailField.text?.contains("@") ?? false) {
                    email = emailField.text ?? ""
                    validEmail = true
                }
            }
        }
        
        if (pwdField.text != nil) {
            if (pwdField.text?.count ?? 0 > 6) {
                pwd = pwdField.text ?? ""
                validPwd = true
            }
        }
        
        if (validEmail && validPwd) {
            Auth.auth().signIn(withEmail: emailField.text!, password: pwdField.text!) { (user, error) in
                if error != nil {
                    print("ERR")
                    self.showAlert(headingAlert: "Could not sign in.", messageAlert: (error?.localizedDescription)!, actionTitle: "Retry", handleAction: { (action) in
                        
                    })
                } else {
                    self.moveToUserPage()
                }
            }
        }
        
        
    }
    
    func showAlert (headingAlert: String, messageAlert: String, actionTitle: String, handleAction: @escaping (_ action: UIAlertAction) -> ()) {
        var alert: UIAlertController = UIAlertController(title: headingAlert, message: messageAlert, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: actionTitle, style: UIAlertAction.Style.default, handler: handleAction))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func moveToUserPage() {
        var storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let userVC: UIViewController = storyBoard.instantiateViewController(withIdentifier: "homeVC")
        self.present(userVC, animated: true, completion: nil)
    }
    
}
