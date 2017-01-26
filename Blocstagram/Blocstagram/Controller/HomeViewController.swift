//
//  HomeViewController.swift
//  Blocstagram
//
//  Created by ddenis on 1/1/17.
//  Copyright © 2017 ddApps. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import SDWebImage


class HomeViewController: UIViewController {

    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    var posts = [Post]()
    var users = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // for performance set an estimated row height
        tableView.estimatedRowHeight = 571
        // but also request to dynamically adjust to content using AutoLayout
        tableView.rowHeight = UITableViewAutomaticDimension
        
        //tableView.delegate = self
        tableView.dataSource = self
        
        loadPosts()
    }
    
    
    // MARK: - Log Out User Method
    
    @IBAction func logout(_ sender: Any) {
        // Log out user from Firebase
        do {
            try FIRAuth.auth()?.signOut()
        } catch let signOutError {
            print("Sign Out Error: \(signOutError.localizedDescription)")
            return
        }
        
        // Present the Sign In VC
        let storyboard = UIStoryboard(name: "Start", bundle: nil)
        let signInVC = storyboard.instantiateViewController(withIdentifier: "SignInViewController")
        present(signInVC, animated: true)
    }
    
    
    // MARK: - Firebase Data Loading Method
    
    func loadPosts() {
        activityIndicatorView.startAnimating()
        
        API.Post.observePosts { (newPost) in
            guard let userID = newPost.uid else { return }
            self.fetchUser(uid: userID, completed: {
                // append the new Post and Reload after the user
                // has been cached
                self.posts.append(newPost)
                self.activityIndicatorView.stopAnimating()
                self.tableView.reloadData()
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
    
    
    // MARK: - Prepare for Segue to CommentVC
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CommentSegue" {
            let commentVC = segue.destination as! CommentViewController
            commentVC.postID = sender as! String
        }
    }
    
}


// MARK: - TableView Delegate and Data Source Methods

extension HomeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeCell", for: indexPath) as! HomeTableViewCell
        
        cell.post = posts[indexPath.row]
        cell.user = users[indexPath.row]
        cell.homeVC = self
    
        return cell
    }
    
}
