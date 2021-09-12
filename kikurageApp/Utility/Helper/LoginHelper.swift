//
//  LoginHelper.swift
//  kikurageApp
//
//  Created by Shusuke Ota on 2021/1/9.
//  Copyright © 2021 shusuke. All rights reserved.
//

import Foundation
import Firebase

class LoginHelper {
    /// シングルトン
    static let shared = LoginHelper()

    private init() {}

    /// 認証ユーザーID
    var kikurageUserId: String? {
        if let user = UserDefaults.standard.object(forKey: Constants.UserDefaultsKey.firebaseUser) as? User {
            if user.isEmailVerified {
                return user.uid
            } else {
                return nil
            }
        }
        return nil
    }
    /// ログイン判定
    var isLogin: Bool {
        guard let user = UserDefaults.standard.object(forKey: Constants.UserDefaultsKey.firebaseUser) as? User else { return false }
        return user.isEmailVerified
    }
}
