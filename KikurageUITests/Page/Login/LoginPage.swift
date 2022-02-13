//
//  LoginPage.swift
//  KikurageUITests
//
//  Created by Shusuke Ota on 2022/2/12.
//  Copyright © 2022 shusuke. All rights reserved.
//

import XCTest

class LoginPage: PageObjectable {
    enum A11y {
        static let pageTitle = "ログイン"
        static let emailTextField = "LoginBaseView_email_textfield"
        static let passwordTextField = "LoginBaseView_password_textfield"
        static let loginButton = "LoginBaseView_login_button"
    }
    
    // MARK: UIElement
    
    var pageTitle: XCUIElement {
        app.navigationBars[A11y.pageTitle].firstMatch
    }
    private var emailTextField: XCUIElement {
        app.textFields["LoginBaseView_email_textfield"]
    }
    private var passwordTextField: XCUIElement {
        app.secureTextFields["LoginBaseView_password_textfield"]
    }
    private var loginButton: XCUIElement {
        app.buttons["LoginBaseView_login_button"]
    }
    
    // MARK: Login

    func login() {
        emailTextField.tap()
        emailTextField.typeText(createUniqueEmail())
        
        passwordTextField.tap()
        passwordTextField.typeText("test123")
        
        let loginButton = app.buttons["LoginBaseView_login_button"]
        loginButton.tap()
    }
}

// MARK: - Stub

extension LoginPage {
    private func createUniqueEmail() -> String {
        //"test+\(Date().timeIntervalSince1970)@kikurage.com"
        let num = Int.random(in: 1..<200)
        return "test\(num)@kikurage.com"
    }
}
