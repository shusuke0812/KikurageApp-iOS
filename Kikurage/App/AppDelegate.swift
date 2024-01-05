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
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        configCrashlyticsUserID()

        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.keyboardDistanceFromTextField = 40

        MXMetricManager.shared.add(self)

        openTopPage()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {}

    func applicationDidEnterBackground(_ application: UIApplication) {}

    func applicationWillEnterForeground(_ application: UIApplication) {}

    func applicationDidBecomeActive(_ application: UIApplication) {}

    func applicationWillTerminate(_ application: UIApplication) {
        MXMetricManager.shared.remove(self)
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

    private func configCrashlyticsUserID() {
        let userID = LoginHelper.shared.kikurageUserID ?? "no id"
        Crashlytics.crashlytics().setUserID(userID)
    }
}

// MARK: - MXMetricManagerSubscriber

extension AppDelegate: MXMetricManagerSubscriber {
    func didReceive(_ payloads: [MXMetricPayload]) {
        payloads.forEach { payload in
            let jsonData = payload.jsonRepresentation()
            let jsonString = String(data: jsonData, encoding: .utf8)
            // ex. send user log to Log server
            KLogger.debug("\(jsonString)")
        }
    }

    @available(iOS 14.0, *)
    func didReceive(_ payloads: [MXDiagnosticPayload]) {
        payloads.forEach { payload in
            let jsonData = payload.jsonRepresentation()
            let jsonString = String(data: jsonData, encoding: .utf8)
            // ex. send user log to Log server
            KLogger.debug("\(jsonString)")
        }
    }
}
