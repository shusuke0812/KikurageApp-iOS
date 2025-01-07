//
//  AppDelegateConfig.swift
//  KikurageService
//
//  Created by Shusuke Ota on 2025/1/5.
//

import FirebaseCore
import FirebaseCrashlytics
import Foundation
import KDLoginManager

public class AppDelegateConfig {
    private let loginManager: LoginManager

    public init() {
        loginManager = LoginManager()
    }

    public func initialize() {
        FirebaseApp.configure()
        initializeCrashlyticsUserID()
    }

    private func initializeCrashlyticsUserID() {
        let userID = loginManager.userID ?? "no id"
        Crashlytics.crashlytics().setUserID(userID)
    }
}
