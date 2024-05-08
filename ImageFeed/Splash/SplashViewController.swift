//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Дмитрий Жуков on 4/11/24.
//

import UIKit

final class SplashViewController: UIViewController {
    
    private let storage = OAuth2TokenStorage()
    private let oAuth2Service = OAuth2Service.shared
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    private let splashViewIdentifier = "SplashViewSegueIdentifier"
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        if let token = storage.token {
            fetchProfile(token: token)
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
        guard let token = storage.token else { return }
        print(token)
        fetchProfile(token: token)
    }
    
    private func fetchProfile(token: String) {
        UIBlockingProgressHUD.show()
        profileService.fetchProfile(token) { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            guard let self = self else { return }
            switch result {
            case .success(_):
                guard let userName = self.profileService.profile?.userName else {return}
                self.fetchProfileImageURL(userName: userName)
                self.switchToTabBarController()
            case .failure(let failure):
                print(failure.localizedDescription)
                // TODO [Sprint 11] Покажите ошибку получения профиля
                break
            }
        }
    }
    
    private func fetchProfileImageURL(userName: String) {
        profileImageService.fetchProfileImageURL(userName: userName) { result in
            switch result {
            case .success(let avatarURL):
                
                print(avatarURL)
            case .failure(let failure):
                print(failure.localizedDescription)
                break
            }
        }
    }
}
//extension SplashViewController: AuthViewControllerDelegate {
//    func didAuthenticate(_ vc: AuthViewController) {
//        vc.dismiss(animated: true)
//        guard storage.token != nil else {return}
//        switchToTabBarController()
//    }
//}

//    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
//        vc.dismiss(animated: true)
//        fetchOAuthToken(code)
//    }

//    private func fetchOAuthToken(_ code: String) {
//        UIBlockingProgressHUD.show()
//        oAuth2Service.fetchOAuthToken(code: code) { [weak self] result in
//            guard let self = self else { return }
//            UIBlockingProgressHUD.dismiss()
//            switch result {
//            case .success(let accessToken):
//                self.storage.token = accessToken
//                self.fetchProfile(token: accessToken)
//                guard let userName = profileService.profile?.userName else {return}
//                self.fetchProfileImageURL(username: userName)
//            case .failure(_):
//                break
//            }
//        }
//    }
