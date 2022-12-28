//
//  AppDelegate.swift
//  ImageMemorize
//
//  Created by Horizon on 27/12/2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {


    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.backgroundColor = UIColor.white
        
        let mainNC = MWPuzzleBaseNC(rootViewController: MWMainViewController())
        self.window?.rootViewController = mainNC
        self.window?.makeKeyAndVisible()
        
        return true
    }
}

