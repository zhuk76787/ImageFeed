//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Дмитрий Жуков on 4/11/24.
//

import UIKit

final class SplashViewController: UIViewController {
    
    private let storage = OAuth2TokenStorage()
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    private let splashViewIdentifier = "SplashViewSegueIdentifier"
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        if storage.token != nil {
            profileService.fetchProfile { [self] result in
                switch result {
                case .success:
                    profileImageService.fetchProfileImageURL { result in
                        switch result{
                        case.success(let data):
                            print(data)
                        case .failure(let failure):
                            print(failure.localizedDescription )
                        }
                    }
                    DispatchQueue.main.async{
                        self.switchToTabBarController()
                    }
                case .failure(let failure):
                    print(failure.localizedDescription )
                }
            }
           
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
        guard storage.token != nil else {return}
        UIBlockingProgressHUD.show()
        profileService.fetchProfile { result in
            UIBlockingProgressHUD.dismiss()
            switch result {
            case.success:
                self.profileImageService.fetchProfileImageURL { result in
                    switch result{
                    case.success(let userData):
                        print(userData)
                    case .failure(let failure):
                        print(failure.localizedDescription )
                    }
                }
                DispatchQueue.main.async{
                    self.switchToTabBarController()
                }
            case.failure(let failure):
                print(failure.localizedDescription )    
            }
        }
        
        //        switchToTabBarController()
    }
}

//extension SplashViewController: AuthViewControllerDelegate {
//    func didAuthenticate(_ vc: AuthViewController) {
//        vc.dismiss(animated: true)
//        guard storage.token != nil else {return}
//        switchToTabBarController()
//    }
//}

