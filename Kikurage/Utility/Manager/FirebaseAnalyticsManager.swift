//
//  FirebaseAnalyticsManager.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2023/8/8.
//  Copyright © 2023 shusuke. All rights reserved.
//

import Foundation
import FirebaseAnalytics

enum FirebaseAnalyticsEvent {
    case debug
    
    var name: String {
        switch self {
        case .debug:
            return "debug_event"
        }
    }
}

struct FirebaseAnalyticsManager {
    static func sendEvent(_ event: FirebaseAnalyticsEvent) {
        Analytics.logEvent(event.name, parameters: [
            AnalyticsParameterItemID: "id-debug-1234",
            AnalyticsParameterItemName: event.name,
            AnalyticsParameterContentType: "content"
        ])
    }
}
