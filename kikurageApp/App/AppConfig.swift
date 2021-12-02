//
//  AppConfig.swift
//  kikurageApp
//
//  Created by Shusuke Ota on 2021/12/2.
//  Copyright © 2021 shusuke. All rights reserved.
//

import Foundation

class AppConfig {
    static let shared = AppConfig()
    private init() {}
    
    // Open URL
    var facebookGroupUrl: String?
    var termsUrl: String?
    var privacyPolicyUrl: String?
}
