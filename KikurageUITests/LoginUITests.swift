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
        let loginPage = TopPage().goToLogin()
        loginPage.login()
    }
}
