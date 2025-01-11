//
//  AppDelegateConfig.swift
//  KikurageService
//
//  Created by Shusuke Ota on 2025/1/5.
//

import Foundation
import FirebaseCore
import KDLoginManager
import KACrashlytics

public class AppDelegateConfig {
    private let loginManager: LoginManager

    public init() {
        loginManager = LoginManager()
    }

    public func initialize() {
        FirebaseApp.configure()
        
        let crashlytics = FirebaseCrashlyticsManager()
        crashlytics.configUserId(loginManager.userID)
    }
}
