//
//  AppDelegateConfig.swift
//  KikurageService
//
//  Created by Shusuke Ota on 2025/1/5.
//

import KDLoginManager
import FirebaseCore
import FirebaseCrashlytics
import Foundation

public class AppDelegateConfig {
    private let loginManager: LoginManager

    public init() {
        loginManager = LoginManager()
    }
    
    public func initialize() {
        FirebaseApp.configure()
        initializeCrashlyticsUserId()
        
    }
    
    private func initializeCrashlyticsUserId() {
        let userId = loginManager.userId ?? "no id"
        Crashlytics.crashlytics().setUserID(userId)
    }
}
