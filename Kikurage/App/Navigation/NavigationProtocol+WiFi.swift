//
//  NavigationProtocol+WiFi.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2023/03/08.
//  Copyright © 2023 shusuke. All rights reserved.
//

import UIKit

protocol WiFiAccessable: PushNavigationProtocol {
    func pushToWiFiList(selected indexPath: IndexPath)
    func pushToWiFiSetting(selectedSSID: String)
    func pushToWiFiSettingSuccess()
}

extension WiFiAccessable {
    func pushToWiFiList(selected indexPath: IndexPath) {
        let vc = WiFiListViewController(bluetoothPeriperal: bluetoothPeriperal)
        push(to: vc)
    }

    func pushToWiFiSetting(selectedSSID: String) {
        let vc = WiFiSettingViewController(selectedSSID: selectedSSID)
        push(to: vc)
    }

    func pushToWiFiSettingSuccess() {}
}
