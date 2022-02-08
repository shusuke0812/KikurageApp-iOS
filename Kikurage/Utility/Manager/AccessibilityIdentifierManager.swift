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
    
    private static let bundleId = Bundle.main.bundleIdentifier!
    
    private static func className(from filepath: String) -> String {
        let fileName = filepath.components(separatedBy: "/").last
        return fileName?.components(separatedBy: ".").first ?? ""
    }
    
    // MARK: Screen
    
    // Login
    static let loginEmailTextField = bundleId + className(from: #file) + "email_textfield"
    static let loginPasswordTextField = bundleId + className(from: #file) + "password_textfield"
    static let loginLoginButton = bundleId + className(from: #file) + "login_button"
}
