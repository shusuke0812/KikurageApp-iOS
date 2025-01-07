//
//  AppConfig.swift
//  KikurageService
//
//  Created by Shusuke Ota on 2025/1/2.
//

import Foundation

public class AppConfig {
    public static let shared = AppConfig()

    private init() {}

    public var facebookGroupURLString: String?
    public var termsURLString: String?
    public var privacyPolicyURLString: String?

    public var navigationBarHeight: CGFloat?
    public var safeAreaHeight: CGFloat?

    public var latestAppVersion: AppVersion?
}
