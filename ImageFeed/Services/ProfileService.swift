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
    private var task: URLSessionTask?
    private var lastCode: String?
    private(set) var profile: Profile?
    
    private func createProfileRequest(code: String) -> URLRequest? {
        var urlComponents = URLComponents(string: Constants.defaultBaseURL)
        urlComponents?.queryItems = [URLQueryItem(name: "me", value: Constants.getTheUserProfile)]
        
        guard let url = urlComponents?.url else {
            assertionFailure("Failed to create URL")
            return nil
        }
        var request = URLRequest(url: url)
        request.setValue("Bearer \(oAuth2TokenStorage)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        assert(Thread.isMainThread)
        guard lastCode != token else {
            completion(.failure(ProfileServiceError.invalidRequest))
            return
        }
        task?.cancel()
        lastCode = token
        guard let request = createProfileRequest(code: token) else {
            completion(.failure(ProfileServiceError.invalidRequest))
            return
        }
        let task = URLSession.shared.data(for: request) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    do {
                        let decoder = JSONDecoder()
                        decoder.keyDecodingStrategy = .convertFromSnakeCase
                        let profileResult = try decoder.decode(ProfileResult.self, from: data)
                        let profile = Profile(userName: profileResult.userName, name: profileResult.firstName + " " + (profileResult.lastName ?? "") , loginName: "@\(profileResult.userName)", bio: (profileResult.bio ?? ""))
                        completion(.success(profile))
                    } catch {
                        completion(.failure(error))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
                self?.task = nil
                self?.lastCode = nil
            }
        }
        self.task = task
        task.resume()
    }
}
