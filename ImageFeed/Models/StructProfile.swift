//
//  StructProfile.swift
//  ImageFeed
//
//  Created by Дмитрий Жуков on 4/18/24.
//

import Foundation

struct Profile {
    let userName: String
    let name: String
    let loginName: String
    let bio:String?
    init(profileResult: ProfileResult) {
        self.userName = profileResult.userName
        self.name = "\(profileResult.firstName) \(profileResult.lastName ?? "")"
        self.loginName = "@\(profileResult.userName)"
        self.bio = profileResult.bio
    }
}
