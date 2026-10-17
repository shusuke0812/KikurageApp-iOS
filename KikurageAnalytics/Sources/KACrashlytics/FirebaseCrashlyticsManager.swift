//
//  FirebaseCrashlyticsManager.swift
//  KikurageAnalytics
//
//  Created by Shusuke Ota on 2025/1/11.
//

import FirebaseCrashlytics
import FirebaseCore

public struct FirebaseCrashlyticsManager {
    public init() {}

    public func configure() {
        FirebaseApp.configure()
    }

    public func configUserID(_ id: String?) {
        let userID = id ?? "no id"
        Crashlytics.crashlytics().setUserID(userID)
    }
}
