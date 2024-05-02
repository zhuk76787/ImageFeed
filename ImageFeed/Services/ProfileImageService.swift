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
    private var task: URLSessionTask?
    private (set) var avatarURL: String?
    
    
//    private func createProfileImageRequest(username: String) -> URLRequest {
//           guard let baseURL = URL(string: Constants.defaultBaseURL) else {
//               preconditionFailure("Unable to construct baseUrl")
//           }
//           guard let url = URL(
//               string: "/users/\(username)",
//               relativeTo: baseURL
//           ) else {
//               assertionFailure("Unable to construct url")
//               return URLRequest(url: URL(string: "")!)
//           }
//           guard let token = storage.token else {
//               assertionFailure("Failed to make token")
//               return URLRequest(url: URL(string: "")!)
//           }
//           var request = URLRequest(url: url)
//           request.httpMethod = "GET"
//           request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
//           print(request)
//           return request
//       }
    
    private func createProfileImageRequest(username: String) -> URLRequest? {
//        guard let userName = profileShared.profile?.userName else {return nil}
        let urlComponents = URLComponents(string: Constants.defaultBaseURL + "/users/:zhuk76787")
//        urlComponents?.queryItems = [
//            URLQueryItem(name: "username", value: Constants.userName)]
        guard let url = urlComponents?.url else {
            assertionFailure("Failed to create URL")
            return nil
        }
        guard let token = storage.token else {return nil}
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        print(request)
        return request
    }
    
    func fetchProfileImageURL(username: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        guard lastUserName != username else {
            completion(.failure(ProfileServiceError.invalidToken))
            return
        }
        task?.cancel()
        lastUserName = username
        
        guard let request = createProfileImageRequest(username: username) else {return}
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
                    let userData = try decoder.decode(UserResult.self, from: data)
                    let avatarURL = userData.profileImage.small
                    completion(.success(avatarURL))
                    print(avatarURL)
                    self.avatarURL = avatarURL
                    self.task = nil
                } catch {
                    completion(.failure(error))
                    print(error)
                    self.lastUserName = nil
                }
            }
        }.resume()
    }
}

            
            
            
            
            
            
            
            
//            let decoder = JSONDecoder()
//            decoder.keyDecodingStrategy = .convertFromSnakeCase
//            do {
//                let userData = try decoder.decode(UserResult.self, from: data)
//                completion(.success(userData))
//                print(userData)
//            } catch {
//                completion(.failure(error))
//                print(error)
//            }
     
