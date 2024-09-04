//
//  AppDelegate.swift
//  otto3
//
//  Created by Cade on 8/10/24.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        // Set default font for UILabel
        UILabel.appearance().font = UIFont(name: "Courier New", size: 17)
                
        // Set default font for UIButton
        UIButton.appearance().titleLabel?.font = UIFont(name: "Courier New", size: 17)
                
        // Set default font for UITextField
        UITextField.appearance().font = UIFont(name: "Courier New", size: 17)
                
        // Set default font for UITextView
        UITextView.appearance().font = UIFont(name: "Courier New", size: 17)
        
        // Ensure app starts in portrait mode
        let mainViewController = MainViewController()
        let navigationController = UINavigationController(rootViewController: mainViewController)
        
        // Initialize the window and set the root view controller
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()

        return true
    }

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}
