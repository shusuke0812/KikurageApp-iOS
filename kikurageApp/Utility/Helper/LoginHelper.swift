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
        if let userData = UserDefaults.standard.object(forKey: Constants.UserDefaultsKey.firebaseUser) as? Data {
            do {
                if let user = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(userData) as? User {
                    return user.isEmailVerified ? user.uid : nil
                }
            } catch {
                print("DEBUG: ユーザー情報の取得に失敗 -> " + error.localizedDescription)
            }
        }
        return nil
    }
    /// ログイン判定
    var isLogin: Bool {
        if let userData = UserDefaults.standard.object(forKey: Constants.UserDefaultsKey.firebaseUser) as? Data {
            do {
                if let user = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(userData) as? User {
                    return user.isEmailVerified
                }
            } catch {
                print("DEBUG: ユーザー情報の取得に失敗 -> " + error.localizedDescription)
            }
        }
        return false
    }
}
