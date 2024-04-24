//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Дмитрий Жуков on 4/18/24.
//

import UIKit

enum ProfileServiceError: Error {
    case invalidRequest
}

final class ProfileService {
    
    var oAuth2TokenStorage = OAuth2TokenStorage()
    static let shared = ProfileService(); private init() {}
    
    private func createProfileRequest() -> URLRequest? {
        let urlComponents = URLComponents(string: Constants.defaultBaseURL + "/me" )
        
        guard let url = urlComponents?.url else {
            assertionFailure("Failed to create URL")
            return nil
        }
        var request = URLRequest(url: url)
        request.setValue("Bearer \(oAuth2TokenStorage.token)", forHTTPHeaderField: "Authorization")
        print(request)
        return request
    }
    
    func fetchProfile( completion: @escaping (Result<ProfileResult, Error>) -> Void) {
        guard let request = createProfileRequest() else {
            completion(.failure(ProfileServiceError.invalidRequest))
            return
        }
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data else {
                if let error {
                    completion(.failure(error))
                }
              
                return
            }
 //          print( String(data: data, encoding: .utf8))
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            do {
                let profileData = try decoder.decode(ProfileResult.self, from: data)
                completion(.success(profileData))
            } catch {
                print(String(describing: error))
            }
        }.resume()
    }
}
