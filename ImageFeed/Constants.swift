//
//  Constants.swift
//  ImageFeed
//
//  Created by Дмитрий Жуков on 4/2/24.
//

import Foundation

enum Constants {
    static let accessKey = "IUWwtlkoq30Hemroqdz817cXMaWeMxJZEH1Nk_Wy9pg"
    static let secretKey = "Hkazhu_VURyfKlf5ZRiNHzTeDmAax07-hK_qKFLoxmY"
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope = "public+read_user+write_likes"
    static let defaultBaseURL = "https://api.unsplash.com"
    static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
}

enum WebViewConstants {
    static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
    static let urlComponentsPath = "/oauth/authorize/native"
}
