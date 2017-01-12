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
import FirebaseStorage


class SignUpViewController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var profileImageView: UIImageView!
    
    var selectedProfilePhoto: UIImage?
    
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
        
        // add a tap gesture to the profile image for users to pick their avatar
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleProfileImageView))
        profileImageView.addGestureRecognizer(tapGesture)
        profileImageView.isUserInteractionEnabled = true
        
        // set handlers to text field objects
        handleTextField()
        
        // initially disable button
        disableButton()
    }
    
    
    // MARK: - Handle the User Profile Picking
    func handleProfileImageView() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        present(imagePickerController, animated: true)
    }
    
    
    // MARK: - Handle the Text Fields
    func handleTextField() {
        usernameTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        emailTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    
    func textFieldDidChange() {
        // guard against username, email and password all not being empty
        guard
            let username = usernameTextField.text, !username.isEmpty,
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
        signupButton.isEnabled = false
        signupButton.alpha = 0.2
    }
    
    
    func enableButton() {
        signupButton.isEnabled = true
        signupButton.alpha = 1.0
    }
    
    
    // MARK: - Sign Up User Method
    
    @IBAction func signUp(_ sender: Any) {
        // convert selected image to JPEG Data format to push to file store
        if let profileImage = self.selectedProfilePhoto, let imageData = UIImageJPEGRepresentation(profileImage, 0.1) {
            AuthService.signUp(username: usernameTextField.text!, email: emailTextField.text!, password: passwordTextField.text!, imageData: imageData, onSuccess: {
                // segue to the Tab Bar Controller
                self.performSegue(withIdentifier: "signUpToTabBar", sender: nil)
            }, onError: { (errorString) in
                print(errorString!)
            })
        } else {
            print("Profile Image can not be empty.")
        }
    }
    
}


// MARK: - ImagePicker Delegate Methods

extension SignUpViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            profileImageView.image = image
            selectedProfilePhoto = image
        }
        
        dismiss(animated: true)
    }
    
}
