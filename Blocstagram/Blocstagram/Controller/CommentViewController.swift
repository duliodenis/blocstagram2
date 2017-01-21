//
//  CommentViewController.swift
//  Blocstagram
//
//  Created by ddenis on 1/20/17.
//  Copyright © 2017 ddApps. All rights reserved.
//

import UIKit

class CommentViewController: UIViewController {

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }

    @IBAction func send(_ sender: Any) {
        
    }
    
}
