//
//  AcknowledgementController.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2022/1/1.
//  Copyright © 2022 shusuke. All rights reserved.
//

import KAAnalytics
import UIKit

struct AcknowledgementControlller {
    static func openSettingApp(onError: (() -> Void)?) {
        if let url = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
            FirebaseAnalyticsManager.sendScreenViewEvent(.acknowledgement)
        } else {
            onError?()
        }
    }
}
