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
    let created_at: Int
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.accessToken = try container.decode(String.self, forKey: .accessToken)
        self.tokenType = try container.decode(String.self, forKey: .tokenType)
        self.scope = try container.decode(String.self, forKey: .scope)
        self.created_at = try container.decode(Int.self, forKey: .created_at)
    }
}
