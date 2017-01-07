//
//  SignUpViewController.swift
//  Blocstagram
//
//  Created by ddenis on 1/1/17.
//  Copyright © 2017 ddApps. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase


class SignUpViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signupButton: UIButton!
    
    
    @IBAction func dismissOnTap(_ sender: Any) {
        dismiss(animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let clouds = UIColor(red: 236/255, green: 240/255, blue: 241/255, alpha: 1)
        
        usernameTextField.backgroundColor = .clear
        usernameTextField.tintColor = .white
        usernameTextField.textColor = .white
        usernameTextField.borderStyle = .none
        
        usernameTextField.attributedPlaceholder = NSAttributedString(string: usernameTextField.placeholder!, attributes: [NSForegroundColorAttributeName: clouds])
        
        let bottomLayerUsername = CALayer()
        bottomLayerUsername.frame = CGRect(x: 0, y: 29, width: 1000, height: 0.6)
        bottomLayerUsername.backgroundColor = UIColor(red: 50/255, green: 50/255, blue: 25/255, alpha: 1).cgColor
        usernameTextField.layer.addSublayer(bottomLayerUsername)
        usernameTextField.clipsToBounds = true
        
        emailTextField.backgroundColor = .clear
        emailTextField.tintColor = .white
        emailTextField.textColor = .white
        emailTextField.borderStyle = .none
        
        emailTextField.attributedPlaceholder = NSAttributedString(string: emailTextField.placeholder!, attributes: [NSForegroundColorAttributeName: clouds])
        
        let bottomLayerEmail = CALayer()
        bottomLayerEmail.frame = CGRect(x: 0, y: 29, width: 1000, height: 0.6)
        bottomLayerEmail.backgroundColor = UIColor(red: 50/255, green: 50/255, blue: 25/255, alpha: 1).cgColor
        emailTextField.layer.addSublayer(bottomLayerEmail)
        emailTextField.clipsToBounds = true
        
        passwordTextField.backgroundColor = .clear
        passwordTextField.tintColor = .white
        passwordTextField.textColor = .white
        passwordTextField.borderStyle = .none
        passwordTextField.attributedPlaceholder = NSAttributedString(string: passwordTextField.placeholder!, attributes: [NSForegroundColorAttributeName: clouds])
        
        let bottomLayerPassword = CALayer()
        bottomLayerPassword.frame = CGRect(x: 0, y: 29, width: 1000, height: 0.6)
        bottomLayerPassword.backgroundColor = UIColor(red: 50/255, green: 50/255, blue: 25/255, alpha: 1).cgColor
        emailTextField.layer.addSublayer(bottomLayerPassword)
        passwordTextField.layer.addSublayer(bottomLayerPassword)
        passwordTextField.clipsToBounds = true
        
        signupButton.layer.cornerRadius = 5
    }
    
    
    // MARK: - Sign Up User Method
    
    @IBAction func signUp(_ sender: Any) {
        // ensure username, email and password are all not nil
        if usernameTextField.text == "" {
            // provide a specific alert
            return
        }
        
        if emailTextField.text == "" {
            // provide a specific alert
            return
        }
        
        if passwordTextField.text == "" {
            // provide a specific alert
            return
        }
        
        // create a Firebase user
        FIRAuth.auth()?.createUser(withEmail: emailTextField.text!, password: passwordTextField.text!, completion: { (user:FIRUser?, error: Error?) in
            if error != nil {
                print("Create User Error: \(error!.localizedDescription)")
            }
            
            // create the new user in the user node
            let ref = FIRDatabase.database().reference()
            let userReference = ref.child("users")
            let uid = user?.uid
            let newUserReference = userReference.child(uid!)
            newUserReference.setValue(["username": self.usernameTextField.text!, "email": self.emailTextField.text!])
            
        })
    }
    
}
