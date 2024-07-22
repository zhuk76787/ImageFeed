//
//  ProfileViewTests.swift
//  ImageFeedTests
//
//  Created by Дмитрий Жуков on 7/23/24.
//

import XCTest
@testable import ImageFeed

final class ProfileViewTests: XCTestCase {
    func testProfileUpdateLabels() {
        let view = ProfileViewControllerMock()
        let profile = Profile(userName: "zhuk",
                              name: "Dmitriy Ivanov",
                              loginName: "@zhuk",
                              bio: "pilot")
        
        view.updateView(data: profile)
        
        XCTAssertEqual(view.nameLabel.text, profile.name)
    }
    
    func testViewDidLoadCallsUpdateProfileDetails() {
        let viewController = ProfileViewController()
        let presenter = ProfilePresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
        _ = viewController.view
        presenter.updateProfileDetails()
        
        XCTAssertTrue(presenter.updateProfileDetailsWasCalled)
    }
    
    func testViewDidLoadCallsUpdateAvatar() {
        let viewController = ProfileViewController()
        let presenter = ProfilePresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
        _ = viewController.view
        presenter.updateAvatar()
        
        XCTAssertTrue(presenter.updateAvatarWasCalled)
    }
    
    func testCallsLogout() {
        let viewController = ProfileViewController()
        let presenter = ProfilePresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
        _ = viewController.view
        presenter.logout()
        
        XCTAssertTrue(presenter.logoutWasCalled)
    }
    
    func testProfileViewControllerUpdateView() {
        let viewController = ProfileViewControllerSpy()
        let presenter = ProfilePresenter()
        viewController.presenter = presenter
        presenter.view = viewController
        
        let profile = Profile(userName: "zhuk",
                              name: "Dmitriy Ivanov",
                              loginName: "@zhuk",
                              bio: "pilot")
        presenter.view?.updateView(data: profile)
        
        XCTAssertTrue(viewController.updateViewWasCalled)
    }
    
    func testProfileViewControllerSetAvatar() {
        let viewController = ProfileViewControllerSpy()
        let presenter = ProfilePresenter()
        viewController.presenter = presenter
        presenter.view = viewController
        
        guard let url = URL(string: Constants.defaultBaseURL) else {return}
        presenter.view?.setAvatar(url: url)
        
        XCTAssertTrue(viewController.setAvatarWasCalled)
    }
}
