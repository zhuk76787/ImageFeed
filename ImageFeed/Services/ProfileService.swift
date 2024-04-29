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
    
    var storage = OAuth2TokenStorage()
    static let shared = ProfileService(); private init() {}
    private(set) var profile: Profile?
    
    private func createProfileRequest() -> URLRequest? {
        let urlComponents = URLComponents(string: Constants.defaultBaseURL + "/me" )
        
        guard let url = urlComponents?.url else {
            assertionFailure("Failed to create URL")
            return nil
        }
        guard let token = storage.token else {return nil}
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    func fetchProfile(completion: @escaping (Result<Profile, Error>) -> Void) {
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
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            do {
                let profileResult = try decoder.decode(ProfileResult.self, from: data)
                let person = Profile(userName: profileResult.username,
                                     name: profileResult.name,
                                     loginName: "@\(profileResult.username)",
                                     bio: profileResult.bio)
                completion(.success(person))
                self.profile = person
                guard let profile = self.profile else {return}
                self.profile = profile
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
