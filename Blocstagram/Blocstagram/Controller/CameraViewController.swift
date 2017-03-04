//
//  CameraViewController.swift
//  Blocstagram
//
//  Created by ddenis on 1/1/17.
//  Copyright © 2017 ddApps. All rights reserved.
//

import UIKit
import FirebaseStorage
import Firebase
import FirebaseAuth


class CameraViewController: UIViewController {
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var captionTextView: UITextView!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var clearBarButton: UIBarButtonItem!
    
    var selectedImage: UIImage?
    
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Make the button a Rounded Rect
        shareButton.layer.cornerRadius = 5
        
        // add a tap gesture to the placeholder image for users to pick
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handlePhotoSelection))
        photoImageView.addGestureRecognizer(tapGesture)
        photoImageView.isUserInteractionEnabled = true
        photoImageView.layer.cornerRadius = 2
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setButtons()
    }
    
    
    // MARK: - Handle the Image Selection and Button UI
    
    func handlePhotoSelection() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        present(imagePickerController, animated: true)
    }
    
    
    // based on the image toggle the buttons
    
    func setButtons() {
        if selectedImage != nil {
            // if there is an image the buttons should be enabled
            shareButton.isEnabled = true
            shareButton.alpha = 1.0
            clearBarButton.isEnabled = true
        } else {
            // otherwise - disable the buttons
            shareButton.isEnabled = false
            shareButton.alpha = 0.2
            clearBarButton.isEnabled = false
        }
    }
    
    
    // MARK: - The Share Action
    
    @IBAction func share(_ sender: Any) {
        // show the progress to the user
        ProgressHUD.show("Sharing started...", interaction: false)
        
        // convert selected image to JPEG Data format to push to file store
        if let photo = selectedImage, let imageData = UIImageJPEGRepresentation(photo, 0.1) {
            
            // get a unique ID
            let photoIDString = NSUUID().uuidString
            
            // get a reference to our file store
            let storeRef = FIRStorage.storage().reference(forURL: Constants.fileStoreURL).child("posts").child(photoIDString)
            
            // push to file store
            storeRef.put(imageData, metadata: nil, completion: { (metaData, error) in
                if error != nil {
                    ProgressHUD.showError("Photo Save Error: \(error?.localizedDescription)")
                    return
                }
                
                // if there's no error
                // get the URL of the photo in the file store
                let photoURL = metaData?.downloadURL()?.absoluteString
                
                // and put the photoURL into the database
                self.saveToDatabase(photoURL: photoURL!)
            
            })
        } else {
            ProgressHUD.showError("Your photo to Share can not be empty. Tap it to set it and Share.")
        }
    }
    
    
    // MARK: - Dismiss Keyboard
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    
    @IBAction func clearInputs() {
        // clear photo, selected image and caption text after saving
        self.captionTextView.text = ""
        self.photoImageView.image = UIImage(named: "placeholder-photo")
        self.selectedImage = nil
        setButtons()
    }
    
    
    // MARK: - Save to Firebase Method
    
    func saveToDatabase(photoURL: String) {
        let ref = FIRDatabase.database().reference()
        let postsReference = ref.child("posts")
        let newPostID = postsReference.childByAutoId().key
        
        let newPostReference = postsReference.child(newPostID)
        guard let currentUserID = FIRAuth.auth()?.currentUser?.uid else { return }
        newPostReference.setValue(["uid": currentUserID,"photoURL": photoURL, "caption": captionTextView.text!]) { (error, reference) in
            if error != nil {
                ProgressHUD.showError("Photo Save Error: \(error?.localizedDescription)")
                return
            }
            
            // associate the user and post
            let myPostReference = API.UserPost.REF_USER_POSTS.child(currentUserID).child(newPostID)
            
            myPostReference.setValue("true", withCompletionBlock: { (error, dbRef) in
                if error != nil {
                    ProgressHUD.showError(error?.localizedDescription)
                    return
                }
            })
            
            ProgressHUD.showSuccess("Photo shared")
            
            self.clearInputs()
            // and jump to the Home tab
            self.tabBarController?.selectedIndex = 0
        }
    }
    
}


// MARK: - ImagePicker Delegate Methods

extension CameraViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            photoImageView.image = image
            selectedImage = image
        }
        
        dismiss(animated: true)
    }
    
}
