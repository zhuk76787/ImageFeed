//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Дмитрий Жуков on 4/3/24.
//

import UIKit

protocol AuthViewControllerDelegate: AnyObject {
    func didAuthenticate(_ vc: AuthViewController)
}

final class AuthViewController: UIViewController {
    private let showWebViewSequeIdentifier = "ShowWebView"
    private let oauth2Service = OAuth2Service.shared
    var oAuth2TokenStorage = OAuth2TokenStorage()
    weak var delegate: AuthViewControllerDelegate?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showWebViewSequeIdentifier {
            guard
                let webViewViewController = segue.destination as? WebViewViewController
            else { fatalError("Failed to prepare for \(showWebViewSequeIdentifier)") }
            webViewViewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
            
            OAuth2Service().fetchOAuthToken(for: code) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let data):
                    do {
                        let oAuthTokenResponseBody = try JSONDecoder().decode(OAuthTokenResponseBody.self, from: data)
                        oAuth2TokenStorage.token = oAuthTokenResponseBody.access_token
                        print("\(String(describing: oAuth2TokenStorage.token))")
                    } catch {
                        //handler(.failure(error))
                    }
                case .failure:
                    print("Ошибка")
                }
            }
        }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        dismiss(animated: true)
    }
}

/*
 private func configureBackButton() {
 
 navigationController?.navigationBar.backIndicatorImage = UIImage(named: "nav_back_button")
 navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "nav_back_button")
 navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
 navigationItem.backBarButtonItem?.tintColor = #colorLiteral(red: 0.1019607843, green: 0.1058823529, blue: 0.1333333333, alpha: 1)
 
 }
 */
