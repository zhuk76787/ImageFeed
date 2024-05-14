//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Дмитрий Жуков on 4/30/24.
//

import UIKit

enum ProfileImageServiceError: Error {
    case invalidRequest
    case invalidData
}

final class ProfileImageService {
    private let profileShared = ProfileService.shared
    private var storage = OAuth2TokenStorage()
    static let shared = ProfileImageService(); private init() {}
    private var lastUserName: String?
    private let uRLSession = URLSession.shared
    private var task: URLSessionTask?
    private (set) var avatarURL: String?
    private (set) var avatarImage: UIImage?
    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    
    
    private func createProfileImageRequest(userName: String) -> URLRequest {
        guard let baseURL = URL(string: Constants.defaultBaseURL) else {
            preconditionFailure("Unable to construct baseUrl")
        }
        guard let url = URL(
            string: "/users/\(userName)",
            relativeTo: baseURL
        ) else {
            assertionFailure("Unable to construct url")
            return URLRequest(url: URL(string: "")!)
        }
        guard let token = storage.token else {
            assertionFailure("Failed to make token")
            return URLRequest(url: URL(string: "")!)
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        print(request)
        return request
    }
    
    func fetchProfileImageURL(userName: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        if lastUserName == userName { return }
        task?.cancel()
        lastUserName = userName
        
        let requestProfileImage = createProfileImageRequest(userName: userName)
        let task = uRLSession.objectTask(for: requestProfileImage) { [weak self] (result: Result<UserResult, Error>) in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                switch result {
                case.success(let profileImageURL):
                    let avatarURL = profileImageURL.profileImage.small
                    self.avatarURL = avatarURL
                    completion(.success(avatarURL))
                    NotificationCenter.default.post(name: ProfileImageService.didChangeNotification,
                                                    object: self,
                                                    userInfo: ["URL": profileImageURL])
                    self.task = nil
                case .failure(let error):
                    print("Ошибка получения ссылки на аватарку профиля: \(error.localizedDescription)")
                    completion(.failure(error))
                    self.lastUserName = nil
                }
            }
        }
        self.task = task
        task.resume()
    }
}

