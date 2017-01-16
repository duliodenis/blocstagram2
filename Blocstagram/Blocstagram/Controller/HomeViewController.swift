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


class HomeViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var posts = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        FIRDatabase.database().reference().child("posts").observe(.childAdded) { (snapshot: FIRDataSnapshot) in
            if let postDictionary = snapshot.value as? [String: Any] {
                
                self.posts.append(Post.transformPost(postDictionary: postDictionary))
                
                self.tableView.reloadData()
            }
        }
    }
    
}


// MARK: - TableView Delegate and Data Source Methods

extension HomeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeCell", for: indexPath)
        cell.textLabel?.text = posts[indexPath.row].caption
        return cell
    }
    
}
