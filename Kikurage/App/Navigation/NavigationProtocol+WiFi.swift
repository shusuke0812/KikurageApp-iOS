//
//  NavigationProtocol+WiFi.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2023/03/08.
//  Copyright © 2023 shusuke. All rights reserved.
//

import KikurageFeature
import UIKit

protocol WiFiAccessable: PushNavigationProtocol {
    func pushToWiFiList(bluetoothPeriperal: KikurageBluetoothPeripheral)
    func pushToWiFiSetting()
    func pushToWiFiSettingSuccess()
}

extension WiFiAccessable {
    func pushToWiFiList(bluetoothPeriperal: KikurageBluetoothPeripheral) {
        let vc = WiFiListViewController(bluetoothPeriperal: bluetoothPeriperal)
        push(to: vc)
    }

    func pushToWiFiSetting() {}

    func pushToWiFiSettingSuccess() {}
}
