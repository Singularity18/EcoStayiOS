//
//  CreateAccount1ViewController.swift
//  
//
//  Created by Akash  Veerappan on 11/17/18.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class CreateAccount1ViewController: UIViewController {


    @IBOutlet weak var createAccountButton: UIButton!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var passwordReentryField: UITextField!
    @IBOutlet weak var dateOfBirthField: UITextField!
    @IBOutlet weak var phoneField: UITextField!
    
    var datePicker: UIDatePicker?
    
    var user: User = User()
    
    var validEmail: Bool = false
    var validName: Bool = false
    var validPwd: Bool = false
    var validPhone: Bool = false
    var validDOB: Bool = false
    
    var authentication = Auth.auth()
    var databaseReference: DatabaseReference = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        dateOfBirthField.inputView = datePicker
        datePicker?.addTarget(self, action: #selector(CreateAccount1ViewController.dateChanged(datePicker:)), for: .valueChanged)
        
        createAccountButton.layer.cornerRadius = 10
        
    }
    
    @objc func dateChanged (datePicker: UIDatePicker) {
        dateOfBirthField.text = getDateString(date: datePicker.date)
    }
    
    @IBAction func onCreateAccountClicked(_ sender: Any) {
        if (nameField.text != nil) {
            if (nameField.text?.count ?? 0 == 0) {
                showAlert(headingAlert: "Name Missing", messageAlert: "The name field left blank. Please enter your name.", actionTitle: "Retry") { (action) in
                }
            } else {
                if (nameField.text?.count ?? 0 >= 1) {
                    user.name = nameField.text ?? ""
                    validName = true
                } else {
                    showAlert(headingAlert: "Incorrect Name", messageAlert: "The name field is entered incorrectly. Please re-enter your name.", actionTitle: "Retry") { (action) in
                    }
                }
            }
        }
        
        if (emailField.text != nil) {
            if (emailField.text?.count ?? 0 == 0) {
                showAlert(headingAlert: "Email Missing", messageAlert: "The email field is left blank. Please enter your email.", actionTitle: "Ok") { (action) in
                }
            } else {
                if (emailField.text?.count ?? 0 >= 1) {
                    if (emailField.text?.contains("@") ?? false) {
                        if emailField.text?.contains(".com") ?? false {
                            user.email = emailField.text ?? ""
                            validEmail = true
                        } else {
                            showAlert(headingAlert: "Incorrect Email", messageAlert: "The email field is entered incorrectly. Please re-enter your email.", actionTitle: "Retry") { (action) in
                            }
                        }
                    } else {
                        showAlert(headingAlert: "Incorrect Email", messageAlert: "The email field is entered incorrectly. Please re-enter your email.", actionTitle: "Retry") { (action) in
                        }
                    }
                } else {
                    showAlert(headingAlert: "Incorrect Email", messageAlert: "The email field is entered incorrectly. Please re-enter your email.", actionTitle: "Retry") { (action) in
                    }
                }
            }
        }
        
        if (passwordField.text != nil) {
            if (passwordField.text?.count ?? 0 == 0) {
                showAlert(headingAlert: "Password Missing", messageAlert: "The password field is left blank. Please enter your password.", actionTitle: "Ok") { (action) in
                }
            } else {
                if (passwordField.text?.count ?? 0 > 5) {
                    if (passwordReentryField.text != nil) {
                        if passwordReentryField.text?.count ?? 0 == 0 {
                            showAlert(headingAlert: "Re-entry Password Field is left blank", messageAlert: "The re-entry password field is left blank. Please enter your password again.", actionTitle: "Ok") { (action) in
                            }
                        } else {
                            if (passwordReentryField.text?.count ?? 0 > 5) {
                                if (passwordReentryField.text == passwordField.text) {
                                    validPwd = true
                                    user.pwd = passwordReentryField.text ?? ""
                                } else {
                                    showAlert(headingAlert: "Passwords don't Match", messageAlert: "The passwords entered do not match eachother. Please retry.", actionTitle: "Retry") { (action) in
                                    }
                                }
                            } else {
                                showAlert(headingAlert: "Password Too Short", messageAlert: "The password entered is too short. Please re-enter your password.", actionTitle: "Retry") { (action) in
                                }
                            }
                        }
                    }
                } else {
                    showAlert(headingAlert: "Password Too Short", messageAlert: "The password entered is too short. Please re-enter your password.", actionTitle: "Retry") { (action) in
                    }
                }
            }
        }
        
        if (dateOfBirthField.text != nil) {
            if dateOfBirthField.text?.count ?? 0 == 0 {
                showAlert(headingAlert: "Date of Birth Missing", messageAlert: "The date of birth field is missing. Please enter your date of birth.", actionTitle: "Ok") { (action) in
                }
            } else {
                if getDateDate(date: (dateOfBirthField?.text)!) == false {
                    showAlert(headingAlert: "Invalid Date", messageAlert: "The date entered is invalid. Please enter your date of birth.", actionTitle: "Ok") { (action) in
                    }
                } else {
                    user.dob = dateOfBirthField.text ?? ""
                    validDOB = true
                }
            }
        }
        
        if (phoneField.text != nil) {
            if (phoneField.text?.count ?? 0 == 0) {
                showAlert(headingAlert: "Phone Number Missing", messageAlert: "The phone number field has been left blank. Please enter your phone number.", actionTitle: "Ok") { (action) in
                }
            } else {
                if (phoneField.text?.count ?? 0 >= 4 && phoneField.text?.count ?? 0 <= 13) {
                    validPhone = true
                    user.phone = phoneField.text ?? ""
                } else {
                    showAlert(headingAlert: "Incorrect Phone Number", messageAlert: "The phone number field is not entered correctly. Please re-enter your phone number.", actionTitle: "Retry") { (action) in
                    }
                }
            }
        }
        
        if (validPhone && validPwd && validName && validEmail && validDOB) {
            authentication.createUser(withEmail: user.email, password: user.pwd) { (user, error) in
                if (error != nil) {
                    self.showAlert(headingAlert: "Authentication Error", messageAlert: (error?.localizedDescription)!, actionTitle: "Retry") { (action) in
                    }
                } else {
                    self.storeData()
                }
            }
        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func storeData() {
        databaseReference = databaseReference.child((authentication.currentUser?.uid)!)
        databaseReference.child("Name").setValue(user.name)
        databaseReference.child("Email").setValue(user.email)
        databaseReference.child("Phone").setValue(user.phone)
        databaseReference.child("DOB").setValue(user.dob)
    }
    
    func showAlert (headingAlert: String, messageAlert: String, actionTitle: String, handleAction: @escaping (_ action: UIAlertAction) -> ()) {
        var alert: UIAlertController = UIAlertController(title: headingAlert, message: messageAlert, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: actionTitle, style: UIAlertAction.Style.default, handler: handleAction))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func getDateString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        if var d: String = dateFormatter.string(from: date) {
            return dateFormatter.string(from: date)
        } else {
            return "Error Decoding Date"
        }
    }
    
    func getDateDate(date: String) -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        if var d: Date = dateFormatter.date(from: date) {
            return true
        } else {
            return false
        }
    }

}
