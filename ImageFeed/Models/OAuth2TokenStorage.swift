//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Дмитрий Жуков on 4/10/24.
//

import UIKit

protocol OAuth2TokenStorageProtocol {
    var token: String? { get set }
}

final class OAuth2TokenStorage: OAuth2TokenStorageProtocol {
    
    private enum Keys: String {
        case token
    }
    
    private let userDefaults = UserDefaults.standard
    
    var token: String? {
        get {
            guard UserDefaults.standard.string(forKey: Keys.token.rawValue) != nil else {
                return ""
            }
            return self.token
        }
        set {
            let _: Void = UserDefaults.standard.set(newValue, forKey: Keys.token.rawValue)
        }
    }
}
