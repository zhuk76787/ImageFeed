//
//  OAuthTokenResponseBody.swift
//  ImageFeed
//
//  Created by Дмитрий Жуков on 4/10/24.
//

import Foundation

struct OAuthTokenResponseBody: Codable {
    let accessToken: String
    let tokenType: String
    let scope: String
    let createdAt: Int64
   private enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case scope
        case createdAt = "created_at"
    }
}
