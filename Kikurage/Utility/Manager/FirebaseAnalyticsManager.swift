//
//  FirebaseAnalyticsManager.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2023/8/8.
//  Copyright © 2023 shusuke. All rights reserved.
//

import FirebaseAnalytics
import Foundation

enum FirebaseAnalyticsTapEvent {
    case debug

    var name: String {
        switch self {
        case .debug:
            return "debug_event"
        }
    }
}

enum FirebaseAnalyticsScreenViewEvent {
    case top
    case login
    case signUp
    case deviceRegister
    case home
    case cultivation
    case cultivationDetail
    case postCultivation
    case recipe
    case postRecipe
    case calendar
    case graph
    case accountSetting
    case acknowledgement
    case dictionary
    case wifi
    
    var screenName: String {
        switch self {
        case .top:
            return "Top"
        case .login:
            return "Login"
        case .signUp:
            return "SignUp"
        case .deviceRegister:
            return "DeviceRegister"
        case .home:
            return "Home"
        case .cultivation:
            return "Cultivation"
        case .cultivationDetail:
            return "CultivationDetail"
        case .postCultivation:
            return "PostCultivation"
        case .recipe:
            return "Recipe"
        case .postRecipe:
            return "PostRecipe"
        case .calendar:
            return "Calendar"
        case .graph:
            return "Graph"
        case .accountSetting:
            return "AccountSetting"
        case .acknowledgement:
            return "Acknowledgment"
        case .dictionary:
            return "Dictionary"
        case .wifi:
            return "WiFi"
        }
    }
    
    var screenClass: String {
        switch self {
        case .top:
            return "app/top"
        case .login:
            return "app/login"
        case .signUp:
            return "app/sign_up"
        case .deviceRegister:
            return "app/device_register"
        case .home:
            return "app/home"
        case .cultivation:
            return "app/home/cultivation"
        case .cultivationDetail:
            return "app/home/cultivation/cultivation_detail"
        case .postCultivation:
            return "app/home/cultivation/post_cultivation"
        case .recipe:
            return "app/home/recipe"
        case .postRecipe:
            return "app/home/recipe/post_recipe"
        case .calendar:
            return "app/home/side_menu/calendar"
        case .graph:
            return "app/home/side_menu/graph"
        case .accountSetting:
            return "app/home/side_menu/account_setting"
        case .acknowledgement:
            return "app/home/side_menu/acknowledgment"
        case .dictionary:
            return "app/home/side_menu/dictionary"
        case .wifi:
            return "app/home/side_menu/wifi"
        }
    }
}

struct FirebaseAnalyticsManager {
    static func sendTapEvent(_ event: FirebaseAnalyticsTapEvent) {
        Analytics.logEvent(event.name, parameters: [
            AnalyticsParameterItemID: "id-debug-1234",
            AnalyticsParameterItemName: event.name,
            AnalyticsParameterContentType: "content"
        ])
    }
    static func sendScreenViewEvent(_ event: FirebaseAnalyticsScreenViewEvent) {
        Analytics.logEvent(AnalyticsEventScreenView, parameters: [
            AnalyticsParameterScreenName: event.screenName,
            AnalyticsParameterScreenClass: event.screenClass
        ])
    }
}
