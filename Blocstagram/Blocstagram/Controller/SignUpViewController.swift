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
    }
    
    
    // MARK: - Handle the User Profile Picking
    func handleProfileImageView() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        present(imagePickerController, animated: true)
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
            
            let uid = user?.uid
            
            // get a reference to our file store
            let storeRef = FIRStorage.storage().reference(forURL: Constants.fileStoreURL).child("profile_image").child(uid!)
            
            // convert selected image to JPEG Data format to push to file store
            if let profileImage = self.selectedProfilePhoto, let imageData = UIImageJPEGRepresentation(profileImage, 0.1) {
                storeRef.put(imageData, metadata: nil, completion: { (metaData, error) in
                    if error != nil {
                        print("Profile Image Error: \(error?.localizedDescription)")
                        return
                    }
                    
                    // if there's no error
                    // get the URL of the profile image in the file store
                    let profileImageURL = metaData?.downloadURL()?.absoluteString
                    
                    // create the new user in the user node and store username, email, and profile image URL
                    let ref = FIRDatabase.database().reference()
                    let userReference = ref.child("users")
                    let newUserReference = userReference.child(uid!)
                    newUserReference.setValue(["username": self.usernameTextField.text!,
                                               "email": self.emailTextField.text!,
                                               "profileImageURL": profileImageURL])
                })
            }
        })
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
