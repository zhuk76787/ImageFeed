//
//  ImagesListServiceSpy.swift
//  ImageFeedTests
//
//  Created by Дмитрий Жуков on 7/23/24.
//

import Foundation
import ImageFeed

final class ImagesListServiceSpy: ImagesListServiceProtocol {
    static let shared = ImagesListServiceSpy()
    private (set) var photos: [Photo] = []
    var photosWereUpdated: Bool = false
        
    func fetchPhotosNextPage() {
        photosWereUpdated = true
    }
    
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {}
}
