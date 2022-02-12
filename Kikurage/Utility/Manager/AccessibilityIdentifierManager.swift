//
//  AccessibilityIdentifierManager.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2022/2/8.
//  Copyright © 2022 shusuke. All rights reserved.
//

import Foundation

enum AccessibilityIdentifierManager {
    // MARK: Common

    private static func className(from filepath: String) -> String {
        let fileName = filepath.components(separatedBy: "/").last
        return fileName?.components(separatedBy: ".").first ?? ""
    }

    // MARK: Screen

    // Top
    static func topLoginButton(file: String = #file) -> String {
        className(from: file) + "_" + "login_button"
    }

    // Login
    static func loginEmailTextField(file: String = #file) -> String {
        className(from: file) + "_" + "email_textfield"
    }
    static func loginPasswordTextField(file: String = #file) -> String {
        className(from: file) + "_" + "password_textfield"
    }
    static func loginLoginButton(file: String = #file) -> String {
        className(from: file) + "_" + "login_button"
    }
}
