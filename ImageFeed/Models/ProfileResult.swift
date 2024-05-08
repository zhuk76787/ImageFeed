//
//  ProfileResult.swift
//  ImageFeed
//
//  Created by Дмитрий Жуков on 4/18/24.
//

import Foundation

struct ProfileResult: Codable {
    var userName: String
    let firstName: String
    let lastName: String?
    var bio: String?
    enum CodingKeys: String, CodingKey {
        case userName = "username"
        case firstName = "first_name"
        case lastName = "last_name"
        case bio 
    }
}







