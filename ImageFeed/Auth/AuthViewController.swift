//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Дмитрий Жуков on 4/3/24.
//

import UIKit

protocol AuthViewControllerDelegate: AnyObject {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String)
}

final class AuthViewController: UIViewController {
    
    weak var delegate: AuthViewControllerDelegate?
    
    private let showWebViewSegueIdentifier = "ShowWebView"
    private let buttonView = UIButton()
    
    override func viewDidLoad() {
        setupView()
        
        configureBackButton()
        
    }
    
    @objc
    private func didTapLogonButton() {
        segueToWebView()
    }
    
    @objc
        private func didTapBackButton() {
            dismiss(animated: true, completion: nil)
        }
}

extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        delegate?.authViewController(self, didAuthenticateWithCode: code)
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        dismiss(animated: true, completion: nil)
    }
}

extension AuthViewController {
    private func setupView() {
        view.backgroundColor = #colorLiteral(red: 0.1352768838, green: 0.1420838535, blue: 0.1778985262, alpha: 1)
        setupLogo()
        setupLogonButton()
    }
    
    private func setupLogo() {
        let logoImage = UIImage(named: "Logo_of_Unsplash")
        let imageView = UIImageView(image: logoImage)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 60),
            imageView.heightAnchor.constraint(equalToConstant: 60),
            imageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
        ])
    }
    
    private func setupLogonButton() {
        buttonView.addTarget(self, action: #selector(self.didTapLogonButton), for: .touchUpInside)
        buttonView.setTitle("Войти", for: .normal)
        buttonView.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        buttonView.setTitleColor(#colorLiteral(red: 0.1352768838, green: 0.1420838535, blue: 0.1778985262, alpha: 1), for: .normal)
        buttonView.backgroundColor = #colorLiteral(red: 1, green: 0.9999999404, blue: 1, alpha: 1)
        buttonView.layer.cornerRadius = 16
        buttonView.layer.masksToBounds = true
        buttonView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonView)
        
        NSLayoutConstraint.activate([
            buttonView.heightAnchor.constraint(equalToConstant: 48),
            buttonView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -90),
            buttonView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            buttonView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        ])
    }
    
    private func configureBackButton() {
        navigationController?.navigationBar.backIndicatorImage = UIImage(named: "nav_back_button")
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "nav_back_button")
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", 
                                                           style: .plain,
                                                           target: nil,
                                                           action: nil)
        navigationItem.backBarButtonItem?.tintColor = #colorLiteral(red: 0.1352768838, green: 0.1420838535, blue: 0.1778985262, alpha: 1)
    }
    
    func segueToWebView() {
            let webViewVewController = WebViewViewController()
            webViewVewController.delegate = self
            webViewVewController.modalPresentationStyle = .fullScreen
            self.present(webViewVewController, animated: true, completion: nil)
        }
}

