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
    private (set) var avatarURL: String?
    
    private func createProfileImageRequest() -> URLRequest? {
//        guard let userName = profileShared.profile?.userName else {return nil}
        var urlComponents = URLComponents(string: Constants.defaultBaseURL + "/users/:username")
        urlComponents?.queryItems = [
            URLQueryItem(name: "username", value: Constants.userName)]
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
    
    func fetchProfileImageURL(completion: @escaping (Result<Data, Error>) -> Void) {
        guard let request = createProfileImageRequest() else {
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
            completion(.success(data))
            print(String(data: data, encoding: String.Encoding.utf8)!)
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
     
