//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Дмитрий Жуков on 4/10/24.
//

import Foundation

final class OAuth2TokenStorage {
    
    private let tokenKey = "Bearer Token"
    
    var token: String? {
        get {return UserDefaults.standard.string(forKey: tokenKey)}
        set {UserDefaults.standard.set(newValue, forKey: tokenKey)}
    }
}
