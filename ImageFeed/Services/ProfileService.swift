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
    var profile: Profile?
    private var lastToken: String?
    private var task: URLSessionTask?
    
    private func createProfileRequest(token: String) -> URLRequest? {
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
        
        guard let request = createProfileRequest(token: token) else {
            completion(.failure(ProfileServiceError.invalidRequest))
            return
        }
        let session = URLSession.shared
        let task = session.objectTask(for: request) { [weak self] (result: Result<ProfileResult, Error>) in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let profileResult):
                    let profile = self.prepareProfile(data: profileResult)
                    self.profile = profile
                    print(profile)
                    completion(.success(profile))
                    
                    self.task = nil
                case .failure(let error):
                    print("Ошибка получения информации профиля: \(error.localizedDescription)")
                    completion(.failure(error))
                    self.lastToken = nil
                }
            }
        }
        task.resume()
    }
    func prepareProfile(data: ProfileResult) -> Profile {
           let username = data.userName
           let name = data.firstName + " " + (data.lastName ?? "")
           let loginName = "@" + data.userName
           let bio = data.bio
           let profile = Profile(userName: username,
                                 name: name,
                                 loginName: loginName,
                                 bio: bio)
           return profile
       }
}
