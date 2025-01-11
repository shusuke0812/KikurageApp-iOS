//
//  FirebaseCrashlyticsManager.swift
//  KikurageAnalytics
//
//  Created by Shusuke Ota on 2025/1/11.
//

import FirebaseCrashlytics

public struct FirebaseCrashlyticsManager {
    public init() {}

    public func configUserId(_ id: String?) {
        let userId = id ?? "no id"
        Crashlytics.crashlytics().setUserID(userId)
    }
}
