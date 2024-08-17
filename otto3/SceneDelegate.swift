//
//  SceneDelegate.swift
//  otto3
//
//  Created by Cade on 8/10/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Ensure the scene is of type UIWindowScene
        guard let windowScene = (scene as? UIWindowScene) else { return }

        // Create a new UIWindow using the windowScene constructor which takes in a window scene
        window = UIWindow(windowScene: windowScene)

        // Set the root view controller to the MainViewController
        let mainViewController = MainViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        window?.rootViewController = mainViewController

        // Make the window visible
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene moves to an active state.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move to an inactive state.
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
    }
}

