//
//  FirebaseAnalyticsManager.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2023/8/8.
//  Copyright © 2023 shusuke. All rights reserved.
//

import FirebaseAnalytics
import Foundation

// GA4 Recommended events: https://support.google.com/firebase/answer/9267735?sjid=12444164303384159030-AP

enum FirebaseAnalyticsTapEvent {
    case debug
    case communicationFacebookButton
    case accountSettingButton
    case cultivationImageButton
    case recipeImageButton

    var name: String {
        switch self {
        case .debug:
            return "debug"
        case .communicationFacebookButton:
            return "facebook_button"
        case .accountSettingButton:
            return "account_setting"
        case .cultivationImageButton:
            return "cultivation_image"
        case .recipeImageButton:
            return "recipe_image"
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
    case communication
    case recipe
    case postRecipe
    case calendar
    case graph
    case accountSetting
    case acknowledgement
    case dictionaryTrivia
    case dictionaryTwitter
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
        case .communication:
            return "Communication"
        case .calendar:
            return "Calendar"
        case .graph:
            return "Graph"
        case .accountSetting:
            return "AccountSetting"
        case .acknowledgement:
            return "Acknowledgment"
        case .dictionaryTrivia:
            return "Trivia"
        case .dictionaryTwitter:
            return "Twitter"
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
        case .communication:
            return "app/home/communication"
        case .calendar:
            return "app/home/side_menu/calendar"
        case .graph:
            return "app/home/side_menu/graph"
        case .accountSetting:
            return "app/home/side_menu/account_setting"
        case .acknowledgement:
            return "app/home/side_menu/acknowledgment"
        case .dictionaryTrivia:
            return "app/home/side_menu/dictionary/trivia"
        case .dictionaryTwitter:
            return "app/home/side_menu/dictionary/twitter"
        case .wifi:
            return "app/home/side_menu/wifi"
        }
    }
}

struct FirebaseAnalyticsHelper {
    static func sendTapEvent(_ event: FirebaseAnalyticsTapEvent) {
        Analytics.logEvent(AnalyticsEventSelectItem, parameters: [
            AnalyticsParameterItemID: "id_\(event.name)",
            AnalyticsParameterItemName: event.name
        ])
    }

    static func sendScreenViewEvent(_ event: FirebaseAnalyticsScreenViewEvent) {
        Analytics.logEvent(AnalyticsEventScreenView, parameters: [
            AnalyticsParameterScreenName: event.screenName,
            AnalyticsParameterScreenClass: event.screenClass
        ])
    }

    static func setUserProperty(_ deviceModel: String = "M5Stack_GRAY") {
        Analytics.setUserProperty(deviceModel, forName: "device_model")
    }
}
