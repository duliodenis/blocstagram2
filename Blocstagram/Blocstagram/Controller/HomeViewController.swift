//
//  HomeViewController.swift
//  Blocstagram
//
//  Created by ddenis on 1/1/17.
//  Copyright © 2017 ddApps. All rights reserved.
//

import UIKit
import FirebaseAuth

class HomeViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //tableView.delegate = self
        tableView.dataSource = self
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
    
}


// MARK: - TableView Delegate and Data Source Methods

extension HomeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeCell", for: indexPath)
        cell.textLabel?.text = "\(indexPath.row + 1)"
        return cell
    }
    
}
