//
//  FirebaseAnalyticsTapEvent.swift
//  KikurageAnalytics
//
//  Created by Shusuke Ota on 2025/1/11.
//

import Foundation

public enum FirebaseAnalyticsTapEvent {
    case debug
    case communicationFacebookButton
    case accountSettingButton
    case cultivationImageButton
    case recipeImageButton

    public var name: String {
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
