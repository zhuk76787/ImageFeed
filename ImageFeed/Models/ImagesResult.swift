//
//  ImagesResult.swift
//  ImageFeed
//
//  Created by Дмитрий Жуков on 6/30/24.
//

import Foundation

public struct Photo {
    let id: String
    let size: CGSize
    let createdAt: Date?
    let welcomeDescription: String?
    let thumbImageURL: String
    let largeImageURL: String
    var isLiked: Bool

}

struct PhotoResult: Codable {
    let id: String
    let createdAt: String?
    let width: Int
    let height: Int
    let isLiked: Bool
    let description: String?
    let urls: UrlsResult
    
    enum CodingKeys: String, CodingKey {
        case createdAt = "created_at"
        case isLiked = "liked_by_user"
        case id, width, height, description, urls
    }
    
}

struct UrlsResult: Codable {
    let raw: String
    let full: String
    let regular: String
    let small:String
    let thumb: String
}

struct LikeResult: Codable {
    let photo: PhotoResult
}
