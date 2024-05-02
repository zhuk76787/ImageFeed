//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Дмитрий Жуков on 4/18/24.
//

import UIKit

enum ProfileServiceError: Error {
    case invalidRequest
    case invalidToken
}

final class ProfileService {
    
    private var storage = OAuth2TokenStorage()
    static let shared = ProfileService(); private init() {}
    private(set) var profile: Profile?
    private var lastToken: String?
    private var task: URLSessionTask?
    
    private func createProfileRequest() -> URLRequest? {
        let urlComponents = URLComponents(string: Constants.defaultBaseURL + "/me" )
        
        guard let url = urlComponents?.url else {
            assertionFailure("Failed to create URL")
            return nil
        }
        guard let token = storage.token else {return nil}
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        assert(Thread.isMainThread)
        guard lastToken != token else {
            completion(.failure(ProfileServiceError.invalidToken))
            return
        }
                task?.cancel()
                lastToken = token
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
            DispatchQueue.main.async {
                do {
                    let profileResult = try decoder.decode(ProfileResult.self, from: data)
                    let person = Profile(userName: profileResult.username,
                                         name: profileResult.name,
                                         loginName: "@\(profileResult.username)",
                                         bio: profileResult.bio)
                    completion(.success(person))
                    self.profile = person
                    self.task = nil
                } catch {
                    completion(.failure(error))
                    self.lastToken = nil
                }
            }
        }.resume()
    }
}
