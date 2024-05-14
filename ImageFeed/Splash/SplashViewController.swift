//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Дмитрий Жуков on 4/11/24.
//

import UIKit

final class SplashViewController: UIViewController {
    private let imageView = UIImageView()
    weak var authViewController: AuthViewController?
    weak var profileViewController: ProfileViewController?
    private let storage = OAuth2TokenStorage()
    private let oAuth2Service = OAuth2Service.shared
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    private let splashViewIdentifier = "SplashViewSegueIdentifier"
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        setView()
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
    private func setView() {
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
    
    private func goToAuth() {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        guard let viewController: UINavigationController = storyboard.instantiateViewController(withIdentifier: "UINavigationController") as? UINavigationController,
              let authViewController = viewController.viewControllers[0] as? AuthViewController else {
            assertionFailure("Failed to prepare for \(splashViewIdentifier)")
            return
        }
        authViewController.delegate = self
        viewController.modalPresentationStyle = .fullScreen
        present(viewController, animated: true)
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
