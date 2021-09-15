//
//  AppDelegate.swift
//  kikurageApp
//
//  Created by Shusuke Ota on 2019/02/26.
//  Copyright © 2019 shusuke. All rights reserved.
//

import UIKit

import Firebase
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Firebase初期化
        FirebaseApp.configure()
        print("DEBUG: \(FirebaseApp.app()?.name ?? "App name is nil")")
        self.configCrashlyticsUserId()
        // IQKeyboard初期化
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.keyboardDistanceFromTextField = 40
        // ログイン画面を開く
        self.openTopPage()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // アプリを閉じる時に呼ばれる
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // アプリを閉じた時に呼ばれる
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // アプリを開く時に呼ばれる
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // アプリを開いた時に呼ばれる
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // フリックしてアプリを終了させた時に呼ばれる
    }
}

// MARK: - Private
extension AppDelegate {
    private func openTopPage() {
        let window = UIWindow()
        self.window = window
        let vc = AppRootController()
        self.window?.rootViewController = vc
        self.window?.backgroundColor = .white
        self.window?.makeKeyAndVisible()
    }
    private func configCrashlyticsUserId() {
        let userId = LoginHelper.shared.kikurageUserId ?? "no id"
        Crashlytics.crashlytics().setUserID(userId)
    }
}
