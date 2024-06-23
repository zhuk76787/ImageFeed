//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Дмитрий Жуков on 4/11/24.
//

import UIKit
import ProgressHUD

final class SplashViewController: UIViewController {
    
    private let oAuth2TokenStorage = OAuth2TokenStorage()
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    private let alert = AlertPresentor.shared
    private let imageView = UIImageView()
    
    weak var authViewController: AuthViewController?
    
    weak var profileViewController: ProfileViewController?
    
    private let oAuth2Service = OAuth2Service.shared
    private let showAuthenticationScreenSegueIdentifier = "ShowAuthenticationScreen"
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupView()
        if oAuth2TokenStorage.token != nil {
            guard let token = oAuth2TokenStorage.token else { return }
            fetchProfile(token: token)
        } else {
            goToAuth()
        }
    }
}

extension SplashViewController {
    private func setupView() {
        view.backgroundColor = #colorLiteral(red: 0.1352768838, green: 0.1420838535, blue: 0.1778985262, alpha: 1)
        imageViewConfig()
    }
    
    private func imageViewConfig() {
        imageView.image = UIImage(named: "Vector")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 75),
            imageView.heightAnchor.constraint(equalToConstant: 78),
            imageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
        ])
    }
}

extension SplashViewController {
    func goToAuth() {
        let authViewController = AuthViewController()
        authViewController.delegate = self
        authViewController.modalPresentationStyle = .fullScreen
        self.present(authViewController, animated: true, completion: nil)
    }
}

extension SplashViewController: AuthViewControllerDelegate {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        vc.dismiss(animated: true)
        UIBlockingProgressHUD.show()
        oAuth2Service.fetchOAuthToken(code: code) { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            guard let self = self else { return }
            switch result {
            case .success(let accessToken):
                self.oAuth2TokenStorage.token = accessToken
                self.didAuthenticate()
            case .failure(let error):
                alert.showNetworkError(with: error)
                print("[SplashViewController]: \(error)")
                break
            }
        }
    }
    
    func didAuthenticate() {
        self.dismiss(animated: true)
        guard let token = self.oAuth2TokenStorage.token else {
            return
        }
        fetchProfile(token: token)
    }
    
    private func fetchProfile(token: String) {
           profileService.fetchProfile(token) { [weak self] result in
               guard let self = self else { return }
               switch result {
               case .success(let profile):
                   self.profileImageService.fetchProfileImageURL(username: profile.userName) { result in
                       switch result {
                       case .success(let avatarURL):
                           print(avatarURL)
                       case .failure(let failure):
                           print(failure.localizedDescription)
                           break
                       }
                   }
                   self.switchToTabBarController()
               case .failure(let failure):
                   print(failure.localizedDescription)
                   break
               }
           }
       }
}

extension SplashViewController {
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else {
            assertionFailure("[SplashViewController]: Invalid window configuration")
            return
        }
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarViewController")
        window.rootViewController = tabBarController
    }
}
