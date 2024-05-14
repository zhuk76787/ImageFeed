//
//  TabBarController.swift
//  ImageFeed
//
//  Created by Дмитрий Жуков on 5/12/24.
//

import UIKit

final class TabBarController: UITabBarController {
    override func awakeFromNib() {
        super.awakeFromNib()
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let imageListViewController = storyboard.instantiateViewController(identifier: "ImagesListViewController")
        let profileViewController = ProfileViewController()
        profileViewController.tabBarItem = UITabBarItem(title: "",
                                                        image: UIImage(named: "tab_profile_active"),
                                                        selectedImage: nil)
        self.viewControllers = [imageListViewController, profileViewController]
    }
}
