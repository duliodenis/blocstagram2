//
//  CommentViewController.swift
//  Blocstagram
//
//  Created by ddenis on 1/20/17.
//  Copyright © 2017 ddApps. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth


class CommentViewController: UIViewController {

    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var constraintToBottom: NSLayoutConstraint!
    
    var postID: String!
    var comments = [Comment]()
    var users = [User]()
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Comments"
        
        // for performance set an estimated row height
        tableView.estimatedRowHeight = 70
        // but also request to dynamically adjust to content using AutoLayout
        tableView.rowHeight = UITableViewAutomaticDimension
        
        tableView.dataSource = self

        handleTextField()
        prepareForNewComment()
        loadComments()
        
        // Set Keyboard Observers
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardDidShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }

    
    // MARK: - Keyboard Notification Response Methods
    
    func keyboardWillShow(_ notification: NSNotification) {
        let keyboardFrame = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
        UIView.animate(withDuration: 0.3) {
            self.constraintToBottom.constant = keyboardFrame!.height
            self.view.layoutIfNeeded()
        }
    }
    
    func keyboardWillHide(_ notification: NSNotification) {
        UIView.animate(withDuration: 0.3) {
            self.constraintToBottom.constant = 0
            self.view.layoutIfNeeded()
        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    
    // MARK: - Firebase Save Operation
    
    @IBAction func send(_ sender: Any) {
        let ref = FIRDatabase.database().reference()
        let commentsReference = ref.child("comments")
        let newCommentID = commentsReference.childByAutoId().key
        
        let newCommentsReference = commentsReference.child(newCommentID)
        guard let currentUserID = FIRAuth.auth()?.currentUser?.uid else { return }
        
        newCommentsReference.setValue(["uid": currentUserID, "commentText": commentTextField.text!]) { (error, reference) in
            if error != nil {
                ProgressHUD.showError("Photo Save Error: \(error?.localizedDescription)")
                return
            }
            
            let postCommentRef = FIRDatabase.database().reference().child("post-comments").child(self.postID).child(newCommentID)
            postCommentRef.setValue("true", withCompletionBlock: { (error, dbRef) in
                if error != nil {
                    ProgressHUD.showError(error?.localizedDescription)
                    return
                }
            })
            
            self.prepareForNewComment()
            self.view.endEditing(true)
        }
    }
    
    
    // MARK: - Load Comments from Firebase
    
    func loadComments() {
        let postCommentRef = FIRDatabase.database().reference().child("post-comments").child(self.postID)
        postCommentRef.observe(.childAdded) { snapshot in
            API.Comment.observeComments(withPostID: snapshot.key, completion: { (newComment) in
                self.fetchUser(uid: newComment.uid!, completed: {
                    // append the new Comment and Reload after the user
                    // has been cached
                    self.comments.append(newComment)
                    self.tableView.reloadData()
                })
            })
        }
    }
    
    
    // fetch all user info at once and cache it into the users array
    
    func fetchUser(uid: String, completed: @escaping () -> Void) {
        API.User.observeUser(withID: uid) { user in
                self.users.append(user)
                
                completed()
            }
    }
    
    
    // MARK: - UI Methods
    
    func prepareForNewComment() {
        commentTextField.text = ""
        disableButton()
    }
    
    func handleTextField() {
        commentTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    func textFieldDidChange() {
        guard let comment = commentTextField.text, !comment.isEmpty else {
            // disable Send button if comment is blank and return
            disableButton()
            return
        }
        // otherwise enable the Send button
        enableButton()
    }
    
    func enableButton() {
        sendButton.alpha = 1.0
        sendButton.isEnabled = true
    }
    
    func disableButton() {
        sendButton.alpha = 0.2
        sendButton.isEnabled = false
    }
    
}


// MARK: - TableView Delegate and Data Source Methods

extension CommentViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as! CommentTableViewCell
        
        cell.comment = comments[indexPath.row]
        cell.user = users[indexPath.row]
        
        return cell
    }
    
}
