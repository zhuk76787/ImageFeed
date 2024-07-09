//
//  ProfileLogoutService.swift
//  ImageFeed
//
//  Created by Дмитрий Жуков on 7/7/24.
//

import WebKit
import Foundation


final class ProfileLogoutService {
    
   static let shared = ProfileLogoutService()
    private let profileService = ProfileService.shared
    private let profileImagesService = ProfileImageService.shared
    private let imagesListService = ImagesListService.shared
    private var storage = OAuth2TokenStorage()
  
   private init() { }

   func logout() {
       cleanData()
   }

   private func cleanData() {
       storage.resetToken()
       profileService.profile = nil
       profileImagesService.avatarURL = nil
       imagesListService.cleanPhotos()
      HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
      WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
         records.forEach { record in
            WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
         }
      }
   }
}
