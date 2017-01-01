//
//  AppDelegate.swift
//  Blocstagram
//
//  Created by ddenis on 1/1/17.
//  Copyright © 2017 ddApps. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        
        // change the tint color on the Tab Bar to Wet Asphalt
        UITabBar.appearance().tintColor = UIColor(red: 52/255, green: 73/255, blue: 94/255, alpha: 1)
        
        return true
    }
    
}

