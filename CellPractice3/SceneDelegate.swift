//
//  SceneDelegate.swift
//  CellPractice3
//
//  Created by admin29 on 01/11/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)

        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        // Check if the user has agreed to the Privacy Policy
        let hasAgreedToPrivacy = UserDefaults.standard.bool(forKey: "UserAgreedToPrivacy")
        let hasLaunchedBefore = UserDefaults.standard.bool(forKey: "hasLaunchedBefore")

        if !hasAgreedToPrivacy {
            // Show Privacy Policy first
            window?.rootViewController = PrivacyViewController()
        } else if !hasLaunchedBefore {
            // Show onboarding for first launch
            let onboardingVC = OnboardingViewController()
            window?.rootViewController = onboardingVC
            // Set hasLaunchedBefore to true after showing onboarding
            UserDefaults.standard.set(true, forKey: "hasLaunchedBefore")
        } else {
            // Show main view controller for subsequent launches
            let mainVC = storyboard.instantiateViewController(withIdentifier: "MainViewController")
            window?.rootViewController = mainVC
        }

        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) { }

    func sceneDidBecomeActive(_ scene: UIScene) { }

    func sceneWillResignActive(_ scene: UIScene) { }

    func sceneWillEnterForeground(_ scene: UIScene) { }

    func sceneDidEnterBackground(_ scene: UIScene) { }
}


