//
//  ImageFeedUITests.swift
//  ImageFeedUITests
//
//  Created by Дмитрий Жуков on 7/23/24.
//

import XCTest

final class ImageFeedUITests: XCTestCase {
    private let email: String = ""
    private let password: String = ""
    private let fullName: String = ""
    private let userName: String = "@"
    
    private let app = XCUIApplication()
    
    override func setUpWithError() throws {
        app.launchArguments = ["Test mode"]
        continueAfterFailure = false
        
        app.launch()
    }
    
    func testAuth() throws {
        sleep(3)
        app.buttons["Authenticate"].tap()
        
        let webView = app.webViews["UnsplashWebView"]
        
        XCTAssertTrue(webView.waitForExistence(timeout: 5))

        let loginTextField = webView.descendants(matching: .textField).element
        XCTAssertTrue(loginTextField.waitForExistence(timeout: 5))
        
        loginTextField.tap()
        loginTextField.typeText(email)
        app.buttons["Done"].tap()
        
        let passwordTextField = webView.descendants(matching: .secureTextField).element
        XCTAssertTrue(passwordTextField.waitForExistence(timeout: 5))
        
        passwordTextField.tap()
        passwordTextField.typeText(password)
        webView.swipeUp()
        
        webView.buttons["Login"].tap()
        
        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        
        XCTAssertTrue(cell.waitForExistence(timeout: 10))
    }
 
    func testFeed() throws {
        
        let tablesQuery = app.tables
        let cellToLike = tablesQuery.children(matching: .cell).element(boundBy: 1)
        
        cellToLike.buttons.firstMatch.tap()
        sleep(5)
        cellToLike.buttons.firstMatch.tap()
        
        sleep(5)
        app.swipeUp()
        
        sleep(5)
        app.swipeDown()
        
        sleep(5)
        
        cellToLike.tap()
        
        let image = app.scrollViews.images.element(boundBy: 0)
        XCTAssertTrue(image.waitForExistence(timeout: 60))
        image.pinch(withScale: 3, velocity: 1)
        image.pinch(withScale: 0.5, velocity: -1)
        
        let backNavigationButton = app.buttons["Backward"]
        backNavigationButton.tap()
        print(app.debugDescription)
    }
    
    
    func testProfile() throws {
        sleep(3)
        app.tabBars.buttons.element(boundBy: 1).tap()
        
        let avatarImage = app.images["Avatar image"]
        XCTAssertTrue(avatarImage.waitForExistence(timeout: 5))
        
        XCTAssertTrue(app.staticTexts["\(fullName)"].exists)
        XCTAssertTrue(app.staticTexts["\(userName)"].exists)
        
        app.buttons["Logout button"].tap()
        
        app.alerts["Пока, пока!"].scrollViews.otherElements.buttons["Да"].tap()
    }
}

extension XCUIElement {
    func forceTapElement() {
        if self.isHittable {
            self.tap()
        } else {
            let coordinate: XCUICoordinate = self.coordinate(withNormalizedOffset: CGVector(dx: 0, dy: 0))
            coordinate.tap()
        }
    }
}
