//
//  UserResult.swift
//  ImageFeed
//
//  Created by Дмитрий Жуков on 4/30/24.
//

import Foundation

struct UserResult: Codable {
    let profileImage: Image
    enum CodingKeys: String, CodingKey {
        case profileImage = "profile_image"
    }
    struct Image: Codable{
        let small: String
    }
}
