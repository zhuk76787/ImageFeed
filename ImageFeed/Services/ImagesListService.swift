import UIKit

public protocol ImagesListServiceProtocol {
    func fetchPhotosNextPage()
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void)
}

final class ImagesListService {
    
    static let shared = ImagesListService()
    var photos: [Photo] = []
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private let storage = OAuth2TokenStorage()
    private var lastLoadedPage: Int?
    private let dateFormatter = ISO8601DateFormatter()
    
    private init() {}
    
    private func createImagesRequest(page: Int) -> URLRequest? {
        guard let urlAPI = URL(string: Constants.defaultBaseURL),
              let token = storage.token else { return nil }
        
        var urlComponents = URLComponents(url: urlAPI, resolvingAgainstBaseURL: false)
        urlComponents?.path = "/photos"
        urlComponents?.queryItems = [
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "per_page", value: "10")
        ]
        
        guard let url = urlComponents?.url else { return nil }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    func fetchPhotosNextPage() {
        guard task == nil else { return }
        let nextPage = (lastLoadedPage ?? 0) + 1
        lastLoadedPage = nextPage
        guard let request = createImagesRequest(page: nextPage) else { return }
        task = urlSession.objectTask(for: request) { [weak self] (result: Result<[PhotoResult], Error>) in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let photoResults):
                    self.photos.append(contentsOf: photoResults.map { $0.toPhoto(dateFormatter: self.dateFormatter) })
                    NotificationCenter.default.post(name: ImagesListService.didChangeNotification, object: self, userInfo: ["photos": self.photos])
                case .failure(let error):
                    print("Error fetching photos: \(error)")
                }
                self.task = nil
            }
        }
        task?.resume()
    }
    
    func changeLike(photoId: String, isLiked: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
        guard task == nil,
              var request = likePhotoRequest(photoId: photoId) else { return }
        request.httpMethod = isLiked ? "DELETE" : "POST"
        task = urlSession.objectTask(for: request) { [weak self] (result: Result<LikeResult, Error>) in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(_):
                    if let index = self.photos.firstIndex(where: { $0.id == photoId }) {
                        self.photos[index].isLiked.toggle()
                        completion(.success(()))
                    }
                case .failure(let error):
                    completion(.failure(error))
                    print("Error changing like: \(error)")
                }
                self.task = nil
            }
        }
        task?.resume()
    }
    
    private func likePhotoRequest(photoId: String) -> URLRequest? {
        guard let url = URL(string: "\(Constants.defaultBaseURL)/photos/\(photoId)/like"),
              let token = storage.token else { return nil }
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    func cleanPhotos() {
        photos = []
    }
}

// Добавим метод для преобразования PhotoResult в Photo
extension PhotoResult {
    func toPhoto(dateFormatter: ISO8601DateFormatter) -> Photo {
        return Photo(
            id: id,
            size: CGSize(width: width, height: height),
            createdAt: dateFormatter.date(from: createdAt ?? ""),
            welcomeDescription: description ?? "",
            thumbImageURL: urls.thumb,
            largeImageURL: urls.full,
            isLiked: isLiked
        )
    }
}
