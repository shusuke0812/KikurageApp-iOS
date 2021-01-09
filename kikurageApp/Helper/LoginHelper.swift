//
//  LoginHelper.swift
//  kikurageApp
//
//  Created by Shusuke Ota on 2021/1/9.
//  Copyright © 2021 shusuke. All rights reserved.
//

import Foundation

class LoginHelper {
    /// ユーザードキュメントId
    internal static var kikurageUserId: String? {
        return UserDefaults.standard.string(forKey: Constants.UserDefaultsKey.userId)
    }
    /// ログイン判定
    internal static var isLogin: Bool {
        return UserDefaults.standard.string(forKey: Constants.UserDefaultsKey.userId) != nil
    }
}
