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
    static let shared = LoginHelper()

    var userListenerHandle: AuthStateDidChangeListenerHandle?
    var user: User?

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
    /// Firebaseユーザー情報を更新
    func userReload(completion: @escaping (() -> Void)) {
        Auth.auth().currentUser?.reload { [weak self] _ in
            self?.userListener {
                completion()
            }
        }
    }
    /// Firebaeユーザーを取得
    func userListener(completion: @escaping (() -> Void)) {
        userListenerHandle = Auth.auth().addStateDidChangeListener { _, user in
            self.user = user
            completion()
        }
    }
    /// Firebaseユーザーリスナをデタッチ
    func userListenerDetach() {
        Auth.auth().removeStateDidChangeListener(userListenerHandle!)  // swiftlint:disable:this force_unwrapping
    }
    /// ユーザー情報を`UserDefaults`へ保存する
    /// - Parameter user: Firebase Auth ユーザー
    func setUserInUserDefaults(user: User) {
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: user, requiringSecureCoding: false)
            UserDefaults.standard.set(data, forKey: Constants.UserDefaultsKey.firebaseUser)
            print("DEBUG: ユーザー情報を`UserDefaults`に保存しました")
        } catch {
            print("DEBUG: ユーザー情報のを`UserDefaults`に保存できませんでした -> " + error.localizedDescription)
        }
    }
}
