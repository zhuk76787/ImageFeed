//
//  Alert.swift
//  ImageFeed
//
//  Created by Дмитрий Жуков on 5/17/24.
//

import UIKit

class AlertPresentor: UIViewController {
    
    static let shared = AlertPresentor()
    
    func showNetworkError() {
        let alert = UIAlertController(
            title: "Что-то пошло не так(",
            message: "Не удалось войти в систему",
            preferredStyle: .alert)
        let action = UIAlertAction(
            title: "ОК",
            style: .default) { _ in
                alert.dismiss(animated: true)
            }
        alert.addAction(action)
        UIApplication.shared.windows.filter{$0.isKeyWindow}
            .first?
            .rootViewController?
            .presentedViewController?
            .present(alert, animated: true, completion: nil)
    }
}
