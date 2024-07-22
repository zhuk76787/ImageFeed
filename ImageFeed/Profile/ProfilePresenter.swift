//
//  ProfilePresenter.swift
//  ImageFeed
//
//  Created by Дмитрий Жуков on 7/23/24.
//

import Foundation

public protocol ProfilePresenterProtocol {
    var view: ProfileViewControllerProtocol? { get set }
    func updateProfileDetails()
    func updateAvatar()
    func logout()
}

final class ProfilePresenter: ProfilePresenterProtocol {
    weak var view: ProfileViewControllerProtocol?
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    private let profileLogoutService = ProfileLogoutService.shared
    
    init(view: ProfileViewControllerProtocol? = nil) {
        self.view = view
    }
    
    func updateAvatar() {
        guard let profileImageURL = profileImageService.avatarURL,
              let url = URL(string: profileImageURL)
        else { return }
        view?.setAvatar(url: url)
    }
    
    func updateProfileDetails() {
        guard let profile = profileService.profile else {
            print("Try to read: profileService.profileModel")
            return
        }
        view?.updateView(data: profile)
    }
    
    func logout() {
        profileLogoutService.logout()
    }
}
