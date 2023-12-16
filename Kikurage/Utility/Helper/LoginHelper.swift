//
//  LoginHelper.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2021/1/9.
//  Copyright © 2021 shusuke. All rights reserved.
//

import Firebase
import Foundation
import KikurageFeature

class LoginHelper {
    static let shared = LoginHelper()

    var userListenerHandle: AuthStateDidChangeListenerHandle?
    var user: User?

    private init() {}

    /// 認証ユーザーID
    var kikurageUserID: String? {
        if let userData = UserDefaults.standard.object(forKey: Constants.UserDefaultsKey.firebaseUser) as? Data {
            do {
                if let user = try NSKeyedUnarchiver.unarchivedObject(ofClass: LoginUser.self, from: userData) {
                    return user.isEmailVerified ? user.uid : nil
                }
            } catch {
                KLogManager.debug(FirebaseAPIError.loadUserError.description() + error.localizedDescription)
            }
        }
        return nil
    }

    /// ログイン判定
    var isLogin: Bool {
        if let userData = UserDefaults.standard.object(forKey: Constants.UserDefaultsKey.firebaseUser) as? Data {
            do {
                if let user = try NSKeyedUnarchiver.unarchivedObject(ofClass: LoginUser.self, from: userData) {
                    return user.isEmailVerified
                }
            } catch {
                KLogManager.debug(FirebaseAPIError.loadUserError.description() + error.localizedDescription)
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
        Auth.auth().removeStateDidChangeListener(userListenerHandle!) // swiftlint:disable:this force_unwrapping
    }

    /// ユーザー情報を`UserDefaults`へ保存する
    /// - Parameter user: Firebase Auth ユーザー
    func setUserInUserDefaults(user: LoginUser) {
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: user, requiringSecureCoding: true)
            UserDefaults.standard.set(data, forKey: Constants.UserDefaultsKey.firebaseUser)
        } catch {
            KLogManager.debug(ClientError.saveUserDefaultsError.description() + error.localizedDescription)
        }
    }

    func logout(onError: (() -> Void)? = nil) {
        do {
            try Auth.auth().signOut()
            let rootVC = UIApplication.shared.windows.first?.rootViewController
            if rootVC is AppRootController, let rootVC = rootVC as? AppRootController {
                rootVC.logout(rootVC: rootVC)
            } else {
                onError?()
            }
        } catch {
            onError?()
        }
    }
}
