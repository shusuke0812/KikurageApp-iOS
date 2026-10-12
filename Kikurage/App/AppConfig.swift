//
//  AppConfig.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2025/1/2.
//

import Foundation

class AppConfig {
    static let shared = AppConfig()

    private init() {}

    var facebookGroupURLString: String?
    var termsURLString: String?
    var privacyPolicyURLString: String?

    var navigationBarHeight: CGFloat?
    var safeAreaHeight: CGFloat?

    var latestAppVersion: AppVersion?
}
