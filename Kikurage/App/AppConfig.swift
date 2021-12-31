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
    var facebookGroupUrl: String?
    var termsUrl: String?
    var privacyPolicyUrl: String?

    // Screen header
    var navigationBarHeight: CGFloat?
    var safeAreaHeight: CGFloat?

    // Date
    var nowDateComponents: DateComponents = DateHelper.getDateComponents()
    var cultivationStartDateComponents: DateComponents?
}
