//
//  LoginUITests.swift
//  KikurageUITests
//
//  Created by Shusuke Ota on 2022/2/11.
//  Copyright © 2022 shusuke. All rights reserved.
//

import XCTest
@testable import Kikurage

class LoginUITests: XCTestCase {
    
    private var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        testLogin()
    }

}

// MARK: - Test

extension LoginUITests {
    private func testLogin() {
        // FIXME: AccessibilityIDの設定方法を考える（Kikurageモジュールで定義したManagerは使えない、理由は不明）
        let button = app.buttons["TopBaseView_login_button"]
        button.tap()

        let emailTextField = app.textFields["LoginBaseView_email_textfield"]
        emailTextField.tap()
        emailTextField.typeText(createUniqueEmail())

        let passwordTextField = app.secureTextFields["LoginBaseView_password_textfield"]
        passwordTextField.tap()
        passwordTextField.typeText("test123")

        let loginButton = app.buttons["LoginBaseView_login_button"]
        loginButton.tap()
    }
}

// MARK: - Stub

extension LoginUITests {
    private func createUniqueEmail() -> String {
        "test+\(Date().timeIntervalSince1970)@kikurage.com"
    }
}
