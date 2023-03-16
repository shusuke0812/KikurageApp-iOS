//
//  AppConfig.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2021/12/2.
//  Copyright © 2021 shusuke. All rights reserved.
//

import UIKit

class AppConfig {
    static let shared = AppConfig()

    private init() {}

    // Open URL
    var facebookGroupURL: String?
    var termsURL: String?
    var privacyPolicyURL: String?

    // Screen header
    var navigationBarHeight: CGFloat?
    var safeAreaHeight: CGFloat?

    // iOS latest version
    var latestAppVersion: AppVersion?
}
