//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Дмитрий Жуков on 4/10/24.
//

import UIKit

final class OAuth2Service {
    static let shared = OAuth2Service()
   // private init() {}
    
    func makeOAuthTokenRequest(code: String) -> URLRequest {
        guard let baseURL = URL(string: "https://unsplash.com") else {
            preconditionFailure("Unable to construct baseUrl")
        }
        guard let url = URL(
            string: "/oauth/token"
            + "?client_id=\(Constants.accessKey)"
            + "&&client_secret=\(Constants.secretKey)"
            + "&&redirect_uri=\(Constants.redirectURI)"
            + "&&code=\(code)"
            + "&&grant_type=authorization_code",
            relativeTo: baseURL
        ) else {
            preconditionFailure("Unable to construct baseUrl")
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        return request
    }
    
    func fetchOAuthToken(for code: String, handler: @escaping (Result<Data,Error>) -> Void) {
        
        let requestWithCode = makeOAuthTokenRequest(code: code)
        
        let task = URLSession.shared.dataTask(with: requestWithCode){ data, response, error in
            if let error = error {
                handler(.failure(error))
                return
            }
            
            if let response = response as? HTTPURLResponse, response.statusCode < 200 || response.statusCode >= 300 {
                handler(.failure(NetworkError.urlSessionError))
                return
            }
            
            guard let data = data else { return }
            handler(.success(data))
        }
        
        task.resume()
    }
}
