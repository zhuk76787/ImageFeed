//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Дмитрий Жуков on 4/3/24.
//

import UIKit

final class AuthViewController: UIViewController {
    private let showWebViewSequeIdentifier = "ShowWebView"
    
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
        //TODO: process code 
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
