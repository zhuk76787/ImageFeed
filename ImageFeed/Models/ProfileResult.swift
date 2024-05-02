//
//  ProfileResult.swift
//  ImageFeed
//
//  Created by Дмитрий Жуков on 4/18/24.
//

import Foundation

struct ProfileResult: Codable {
    var username: String
    var name: String
    var bio: String?
    enum CodingKeys: String, CodingKey {
        case username = "username"
        case name 
        case bio
    }
}







