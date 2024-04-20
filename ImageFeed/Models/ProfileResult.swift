//
//  ProfileResult.swift
//  ImageFeed
//
//  Created by Дмитрий Жуков on 4/18/24.
//

import Foundation

struct ProfileResult: Codable {
    let userName: String
    let firstName: String
    let lastName: String?
    let bio: String?
}

