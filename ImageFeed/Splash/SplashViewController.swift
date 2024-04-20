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
    
    private let profileService = ProfileService()
    private let storage = OAuth2TokenStorage()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if oauthTokenStorage.token != nil {
           // switchToTabBarController()
            fetchProfile(token: oauthTokenStorage.token ?? "")
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
        
        guard let token = storage.token else {return}
        
        fetchProfile(token: token)
    }
    
    private func fetchProfile(token: String) {
            UIBlockingProgressHUD.show()
            profileService.fetchProfile(token) { [weak self] result in
                UIBlockingProgressHUD.dismiss()

                guard let self = self else { return }

                switch result {
                case .success:
                   self.switchToTabBarController()

                case .failure:
                    // TODO [Sprint 11] Покажите ошибку получения профиля
                    break
                }
            }
        }
}
