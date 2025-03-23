//
//  TopPage.swift
//  KikurageUITests
//
//  Created by Shusuke Ota on 2022/2/12.
//  Copyright © 2022 shusuke. All rights reserved.
//

import XCTest

class TopPage: PageObjectable {
    enum A11y {
        static let pageTitle = "ようこそ！"
        static let loginButton = "TopBaseView.loginButton"
    }
    
    // MARK: UIElement
    
    var pageTitle: XCUIElement {
        app.navigationBars[A11y.pageTitle].firstMatch
    }
    private var loginButton: XCUIElement {
        app.buttons[A11y.loginButton]
    }
    
    // MARK: Transition

    @discardableResult
    func goToLogin() -> LoginPage {
        _ = loginButton.waitForExistence(timeout: 5)
        loginButton.tap()
        return LoginPage()
    }
}
