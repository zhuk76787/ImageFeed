//
//  ProfilePresenterSpy.swift
//  ImageFeedTests
//
//  Created by Дмитрий Жуков on 7/23/24.
//

import Foundation
import ImageFeed

final class ProfilePresenterSpy: ProfilePresenterProtocol {
    var view: ImageFeed.ProfileViewControllerProtocol?
    var updateProfileDetailsWasCalled: Bool = false
    var updateAvatarWasCalled: Bool = false
    var logoutWasCalled: Bool = false
    
    func updateProfileDetails() {
        updateProfileDetailsWasCalled = true
    }
    
    func updateAvatar() {
        updateAvatarWasCalled = true
    }
    
    func logout() {
        logoutWasCalled = true
    }
}
