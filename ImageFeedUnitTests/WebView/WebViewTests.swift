//
//  ImageFeedTests.swift
//  ImageFeedTests
//
//  Created by Дмитрий Жуков on 7/22/24.
//
@testable import ImageFeed
import XCTest

final class WebViewTests: XCTestCase {
    
    func testViewDidLoadCallsPresenterViewDidLoad() {
        let viewController = WebViewViewController()
        let presenterSpy = WebViewPresenterSpy()
        viewController.presenter = presenterSpy
        _ = viewController.view
        XCTAssertTrue(presenterSpy.viewDidLoadCalled, "viewDidLoad() должен быть вызван")
    }
    
    func testPresenterCallsLoadRequest() {
        let viewController = WebViewViewControllerSpy()
        let authHelper = AuthHelper()
        guard let delegate = viewController.delegate as? WebViewViewControllerDelegate else {return}
        let presenter = WebViewPresenter(view: viewController, delegate: delegate, authHelper: authHelper)
        viewController.presenter = presenter
        presenter.view = viewController
        presenter.viewDidLoad()
        XCTAssertTrue(viewController.loadRequestCalled)
    }
    
    func testProgressVisibleWhenLessThenOne() {
        let viewController = WebViewViewControllerSpy()
        let authHelper = AuthHelper()
        guard let delegate = viewController.delegate as? WebViewViewControllerDelegate else {return}
        let presenter = WebViewPresenter(view: viewController, delegate: delegate, authHelper: authHelper)
        let progress: Float = 0.6
        let shouldHideProgress = presenter.shouldHideProgress(for: progress)
        XCTAssertFalse(shouldHideProgress)
    }
    
    func testProgressHiddenWhenOne() {
        let viewController = WebViewViewControllerSpy()
        let authHelper = AuthHelper() //Dummy
        guard let delegate = viewController.delegate as? WebViewViewControllerDelegate else {return}
        let presenter = WebViewPresenter(view: viewController, delegate: delegate, authHelper: authHelper)
        let progress: Float = 1.0
        let shouldHideProgress = presenter.shouldHideProgress(for: progress) // return value verification
        XCTAssertTrue(shouldHideProgress)
    }
    
    func testAuthHelperAuthURL() {
        let configuration = AuthConfiguration.standard
        let authHelper = AuthHelper(configuration: configuration)
        
        let url = authHelper.authURL()!
        let urlString = url.absoluteString
        
        XCTAssertTrue(urlString.contains(configuration.authURLString))
        XCTAssertTrue(urlString.contains(configuration.accessKey))
        XCTAssertTrue(urlString.contains(configuration.redirectURI))
        XCTAssertTrue(urlString.contains("code"))
        XCTAssertTrue(urlString.contains(configuration.accessScope))
    }
    
    func testCodeFromURL() {
        var urlComponents = URLComponents(string: "https://unsplash.com/oauth/authorize/native")!
        urlComponents.queryItems = [URLQueryItem(name: "code", value: "test code")]
        let url = urlComponents.url!
        let authHelper = AuthHelper()
        let code = authHelper.code(from: url)
        XCTAssertEqual(code, "test code")
    }
}
