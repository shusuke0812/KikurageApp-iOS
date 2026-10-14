//
//  File.swift
//  KikurageDomain
//
//  Created by Shusuke Ota on 2026/10/14.
//

import Foundation
import KDLoginManager
import KACrashlytics

public protocol ConfigureFirebaseUseCaseProtocol {
    func invoke()
}

public class ConfigureFirebaseUseCase: ConfigureFirebaseUseCaseProtocol {
    private let loginManager: LoginManagerProtocol

    public init(loginManager: LoginManagerProtocol = LoginManager()) {
        self.loginManager = loginManager
    }

    public func invoke() {
        let crashlytics = FirebaseCrashlyticsManager()
        crashlytics.configure()
        crashlytics.configUserID(loginManager.userID)
    }
}
