
import UIKit

final class ProfileImageService {
    
    static var shared = ProfileImageService()
    private let urlSession = URLSession.shared
    private let storage = OAuth2TokenStorage()
    var avatarURL: String?
    private var task: URLSessionTask?
    private var lastUserName: String?
    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    
    private init() {}
    
    private func makeProfileImageRequest(username: String) -> URLRequest? {
        guard let defaultBaseURL = URL(string: Constants.defaultBaseURL) else {
            print("Unable to construct baseUrl")
            return nil
        }
        var urlComponents = URLComponents()
        urlComponents.path = "/users/\(username)"
        guard let url = urlComponents.url(relativeTo: defaultBaseURL) else {
            print("Unable to construct avatar url")
            return nil
        }
        guard let token = storage.token else {
            print("Failed to retrieve token")
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        print(request)
        return request
    }
    
    func fetchProfileImageURL(username: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        if lastUserName == username { return }
        task?.cancel()
        lastUserName = username
        if let request = makeProfileImageRequest(username: username) {
            let task = urlSession.objectTask(for: request) { [weak self] (result: Result<UserResult, Error>) in
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
                        completion(.failure(error))
                        self.lastUserName = nil
                    }
                }
            }
            self.task = task
            task.resume()
        } else {
            print("Failed to create profile image request")
        }
        
    }
}
