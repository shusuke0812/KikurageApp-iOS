//
//  AppDelegateConfig.swift
//  KikurageService
//
//  Created by Shusuke Ota on 2025/1/5.
//

import FirebaseCore
import Foundation
import KACrashlytics
import KDLoginManager

public class AppDelegateConfig {
    private let loginManager: LoginManager

    public init() {
        loginManager = LoginManager()
    }

    public func initialize() {
        FirebaseApp.configure()

        let crashlytics = FirebaseCrashlyticsManager()
        crashlytics.configUserID(loginManager.userID)
    }
}
