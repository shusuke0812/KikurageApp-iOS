//
//  R.swift
//  KikurageService
//
//  Created by Shusuke Ota on 2025/1/12.
//

import Foundation

enum R {
    enum LocalizableString {
        static let postCultivationValidMemo = string(localized: "screen_post_cultivation_valid_memo")
    }

    private static func string(localized key: String.LocalizationValue) -> String {
        String(localized: key, bundle: .module)
    }
}
