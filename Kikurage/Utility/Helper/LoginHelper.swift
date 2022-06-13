//
//  LoginHelper.swift
//  Kikurage
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
                print(FirebaseAPIError.loadUserError.description() + error.localizedDescription)
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
                print(FirebaseAPIError.loadUserError.description() + error.localizedDescription)
            }
        }
        return false
    }
    /// Firebaseユーザー情報を更新
    func userReload(completion: (() -> Void)? = nil) {
        Auth.auth().currentUser?.reload { [weak self] _ in
            self?.userListener {
                completion?()
            }
        }
    }
    /// Firebaeユーザーを取得
    func userListener(completion: (() -> Void)? = nil) {
        userListenerHandle = Auth.auth().addStateDidChangeListener { _, user in
            self.user = user
            completion?()
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
        } catch {
            print(ClientError.saveUserDefaultsError.description() + error.localizedDescription)
        }
    }
    func logout(onError: (() -> Void)? = nil) {
        // FIXME: Auth.auth().signOutを追加
        let rootVC = UIApplication.shared.windows.first?.rootViewController
        if rootVC is AppRootController, let vc = rootVC as? AppRootController {
            vc.logout(vc: vc)
        } else {
            onError?()
        }
    }
}
