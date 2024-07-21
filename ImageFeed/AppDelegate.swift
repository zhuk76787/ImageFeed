//
//  AppDelegate.swift
//  ImageFeed
//
//  Created by Дмитрий Жуков on 3/1/24.
//

import UIKit
import ProgressHUD

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        ProgressHUD.animationType = .activityIndicator
        ProgressHUD.colorHUD = #colorLiteral(red: 0.1352768838, green: 0.1420838535, blue: 0.1778985262, alpha: 1)
        ProgressHUD.colorAnimation = .lightGray
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        let sceneConfigureation = UISceneConfiguration(name: "Main",
                                                       sessionRole: connectingSceneSession.role)
        sceneConfigureation.delegateClass = SceneDelegate.self
        return sceneConfigureation
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    
}

