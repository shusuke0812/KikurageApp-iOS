//
//  AppDelegateConfig.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2025/1/5.
//

import FirebaseCore
import Foundation
import KACrashlytics
import KDLoginManager

class AppDelegateConfig {
    private let loginManager: LoginManager

    init() {
        loginManager = LoginManager()
    }

    func initialize() {
        FirebaseApp.configure()

        let crashlytics = FirebaseCrashlyticsManager()
        crashlytics.configUserID(loginManager.userID)
    }
}
