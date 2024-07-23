//
//  ProfileViewControllerMock.swift
//  ImageFeedTests
//
//  Created by Дмитрий Жуков on 7/23/24.
//

import Foundation
import ImageFeed
import UIKit

final class ProfileViewControllerMock: ProfileViewControllerProtocol {
    let imageView = UIImageView()
    let exitButton = UIButton()
    let nameLabel = UILabel()
    let idLable = UILabel()
    let statusLable = UILabel()
    
    var presenter: ImageFeed.ProfilePresenterProtocol?
    
    func updateView(data: ImageFeed.Profile) {
        nameLabel.text = data.name
        idLable.text = data.loginName
        statusLable.text = data.bio
    }
    
    func setAvatar(url: URL) {}
}
