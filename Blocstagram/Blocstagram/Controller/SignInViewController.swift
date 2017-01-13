//
//  SignInViewController.swift
//  Blocstagram
//
//  Created by ddenis on 1/1/17.
//  Copyright © 2017 ddApps. All rights reserved.
//

import UIKit
import FirebaseAuth


class SignInViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let clouds = UIColor(red: 236/255, green: 240/255, blue: 241/255, alpha: 1)
        
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
        
        signInButton.layer.cornerRadius = 5
        
        // set handlers to text field objects
        handleTextField()
        
        // initially disable button
        disableButton()
    }
    
    
    // Automatically Log Current User In
    // if there is a current user segue to the tab bar controller in View Did Appear
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if FIRAuth.auth()?.currentUser != nil {
            // segue to the Tab Bar Controller
            self.performSegue(withIdentifier: "signInToTabBar", sender: nil)
        }
    }
    
    
    // MARK: - Handle the Text Fields
    
    func handleTextField() {
        emailTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    
    func textFieldDidChange() {
        // guard against username, email and password all not being empty
        guard
            let email = emailTextField.text, !email.isEmpty,
            let password = passwordTextField.text, !password.isEmpty
            else {
                // disable SignUp button if ANY are not empty
                disableButton()
                return
        }
        // enable SignUp button if they are ALL not empty
        enableButton()
    }
    
    
    func disableButton() {
        signInButton.isEnabled = false
        signInButton.alpha = 0.2
    }
    
    
    func enableButton() {
        signInButton.isEnabled = true
        signInButton.alpha = 1.0
    }
    
    
    // MARK: - Dismiss Keyboard 
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    
    // MARK: - Sign In User Method
    
    @IBAction func signIn(_ sender: Any) {
        //dismiss keyboard
        view.endEditing(true)
        
        // use the signIn class method of the AuthService class
        AuthService.signIn(email: emailTextField.text!, password: passwordTextField.text!, onSuccess: { 
            // on success segue to the Tab Bar Controller
            self.performSegue(withIdentifier: "signInToTabBar", sender: nil)
        }, onError: { errorString in
            print(errorString!)
        })
    }
}
