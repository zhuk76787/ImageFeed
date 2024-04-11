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
            guard let data = userDefaults.data(forKey: Keys.token.rawValue),
                  let token = try? JSONDecoder().decode(String.self, from: data) else {
                return ""
            }
            //
            print("\(token)")
            //
            return token
        }
        set {
            guard let data = try? JSONEncoder().encode(newValue) else {
                print("Невозможно сохранить Bearer Token")
                return
            }
            
            userDefaults.set(data, forKey: Keys.token.rawValue)
        }
    }
}
