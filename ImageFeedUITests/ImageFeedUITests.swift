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
    private let userName: String = ""
    
    private let app = XCUIApplication()
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        
        app.launch()
    }
    
    func testAuth() throws {
            sleep(3)
            
            // Нажать кнопку авторизации
            XCTAssertTrue(app.buttons["Authenticate"].waitForExistence(timeout: 5))
            app.buttons["Authenticate"].tap()
            
            // Подождать, пока экран авторизации открывается и загружается
            let webView = app.webViews["UnsplashWebView"]
            XCTAssertTrue(webView.waitForExistence(timeout: 10))
            
            // Ввести данные в форму
            let loginTextField = webView.descendants(matching: .textField).element
            XCTAssertTrue(loginTextField.waitForExistence(timeout: 5))
            loginTextField.tap()
            loginTextField.typeText(email)
            
            app.buttons["Done"].tap()
            sleep(2)
            
            let passwordTextField = webView.descendants(matching: .secureTextField).element
            XCTAssertTrue(passwordTextField.waitForExistence(timeout: 5))
            passwordTextField.tap()
            passwordTextField.typeText(password)
            webView.swipeUp()
            
            // Нажать кнопку логина
            webView.buttons["Login"].tap()
            
            // Подождать, пока открывается экран ленты
            let tablesQuery = app.tables
            let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
            XCTAssertTrue(cell.waitForExistence(timeout: 10))
        }

    
    func testFeed() throws {
        let tablesQuery = app.tables
        
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        cell.swipeUp()
        
        sleep(2)
        
        let cellToLike = tablesQuery.children(matching: .cell).element(boundBy: 1)
        
        cellToLike.buttons["like_button_off"].tap()
        cellToLike.buttons["like_button_on"].tap()
        
        sleep(2)
        
        cellToLike.tap()
        
        sleep(2)
        
        let image = app.scrollViews.images.element(boundBy: 0)
        // Zoom in
        image.pinch(withScale: 3, velocity: 1) // zoom in
        // Zoom out
        image.pinch(withScale: 0.5, velocity: -1)
        
        let navBackButtonWhiteButton = app.buttons["back_button"]
        navBackButtonWhiteButton.tap()
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
