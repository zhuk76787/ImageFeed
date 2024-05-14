//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Дмитрий Жуков on 4/10/24.
//

import Foundation
import SwiftKeychainWrapper

final class OAuth2TokenStorage {
    private let tokenKey = "Bearer Token"
    var token: String? {
        get {return KeychainWrapper.standard.string(forKey: tokenKey)}
        set {
            guard let newValue else {return}
            KeychainWrapper.standard.set(newValue, forKey: tokenKey)
        }
    }
}
