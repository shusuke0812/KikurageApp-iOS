//
//  File.swift
//  KikurageService
//
//  Created by Shusuke Ota on 2025/1/2.
//

import Foundation


public class AppConfig {
    public static let shared = AppConfig()
    
    private init() {}
    
    public var facebookGroupUrlString: String?
    public var termsUrlString: String?
    public var privacyPolicyUrlString: String?
    
    public var navigationBarHeight: CGFloat?
    public var safeAreaHeight: CGFloat?
    
    public var latestAppVersion: AppVersion?
}
