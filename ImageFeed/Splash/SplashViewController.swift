//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Дмитрий Жуков on 4/11/24.
//

import UIKit

final class SplashViewController: UIViewController {
    
    private let oauthTokenStorage = OAuth2TokenStorage()
    private let splashViewIdentifier = "SplashViewSegueIdentifier"
    
    private let storage = OAuth2TokenStorage()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if oauthTokenStorage.token != nil {
            ProfileService.shared.fetchProfile { result in
                switch result {
                case .success(let profileData):
                    print("Data: \(profileData)")
                case .failure(let failure):
                    print(failure.localizedDescription )
                }
            }
            switchToTabBarController()
           
        } else {
            performSegue(withIdentifier: splashViewIdentifier, sender: nil)
        }
    }
    
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else {
            assertionFailure("Invalid window configuration")
            return
        }
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarViewController")
        
        window.rootViewController = tabBarController
    }
}

extension SplashViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == splashViewIdentifier {
            guard
                let navigationController = segue.destination as? UINavigationController,
                let viewController = navigationController.viewControllers[0] as? AuthViewController
            else {
                assertionFailure("Failed to prepare for \(splashViewIdentifier)")
                return
            }
            viewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

extension SplashViewController: AuthViewControllerDelegate {
    func didAuthenticate(_ vc: AuthViewController) {
        vc.dismiss(animated: true)
        ProfileService.shared.fetchProfile { result in
            switch result {
            case .success(let data):
                print("Data: \(data)")
            case .failure(let failure):
                print(failure.localizedDescription )
            }
        }
        
        guard storage.token != nil else {return}
        
        switchToTabBarController()
        
       
    }
}

