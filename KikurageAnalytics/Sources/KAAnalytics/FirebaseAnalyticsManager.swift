//
//  FirebaseAnalyticsManager.swift
//  KikurageAnalytics
//
//  Created by Shusuke Ota on 2023/8/8.
//  Copyright © 2023 shusuke. All rights reserved.
//

import FirebaseAnalytics
import Foundation

// GA4 Recommended events: https://support.google.com/firebase/answer/9267735?sjid=12444164303384159030-AP

public struct FirebaseAnalyticsManager {
    public static func sendTapEvent(_ event: FirebaseAnalyticsTapEvent) {
        Analytics.logEvent(AnalyticsEventSelectItem, parameters: [
            AnalyticsParameterItemID: "id_\(event.name)",
            AnalyticsParameterItemName: event.name
        ])
    }

    public static func sendScreenViewEvent(_ event: FirebaseAnalyticsScreenViewEvent) {
        Analytics.logEvent(AnalyticsEventScreenView, parameters: [
            AnalyticsParameterScreenName: event.screenName,
            AnalyticsParameterScreenClass: event.screenClass
        ])
    }

    public static func setUserProperty(_ deviceModel: String = "M5Stack_GRAY") {
        Analytics.setUserProperty(deviceModel, forName: "device_model")
    }

    public static func setUserID(_ idString: String) {
        Analytics.setUserID(idString)
    }
}
