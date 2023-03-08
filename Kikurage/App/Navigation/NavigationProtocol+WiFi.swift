//
//  NavigationProtocol+WiFi.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2023/03/08.
//  Copyright © 2023 shusuke. All rights reserved.
//

import UIKit

protocol WiFiAccessable: PushNavigationProtocol {
    func pushToWiFiList()
    func pushToWiFiSetting()
    func pushToWiFiSettingSuccess()
}

extension WiFiAccessable {
    func pushToWiFiList() {
        let vc = WiFiListViewController()
        push(to: vc)
    }
    func pushToWiFiSetting() {
    }
    func pushToWiFiSettingSuccess() {
    }
}
