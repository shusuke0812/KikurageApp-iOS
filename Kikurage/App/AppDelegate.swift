//
//  AppDelegate.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2019/02/26.
//  Copyright © 2019 shusuke. All rights reserved.
//

import FirebaseCore
import FirebaseCrashlytics
import IQKeyboardManagerSwift
import KikurageFeature
import MetricKit
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        KLogManager.debug()
        FirebaseApp.configure()
        configCrashlyticsUserID()

        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.keyboardDistanceFromTextField = 40

        MXMetricManager.shared.add(self)

        return true
    }

    func applicationWillTerminate(_ application: UIApplication) {}

    // MARK: - UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        KLogManager.debug()
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        KLogManager.debug()
        MXMetricManager.shared.remove(self)
    }
}

// MARK: - Private

extension AppDelegate {
    private func configCrashlyticsUserID() {
        let userID = LoginHelper.shared.kikurageUserID ?? "no id"
        Crashlytics.crashlytics().setUserID(userID)
    }
}

// MARK: - MXMetricManagerSubscriber

extension AppDelegate: MXMetricManagerSubscriber {
    func didReceive(_ payloads: [MXMetricPayload]) {
        for payload in payloads {
            let jsonData = payload.jsonRepresentation()
            let jsonString = String(data: jsonData, encoding: .utf8)
            // ex. send user log to Log server
            KLogManager.debug(jsonString ?? "not found")
        }
    }

    @available(iOS 14.0, *)
    func didReceive(_ payloads: [MXDiagnosticPayload]) {
        for payload in payloads {
            let jsonData = payload.jsonRepresentation()
            let jsonString = String(data: jsonData, encoding: .utf8)
            // ex. send user log to Log server
            KLogManager.debug(jsonString ?? "not found")
        }
    }
}
