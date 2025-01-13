//
//  WiFiSettingViewModel.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2023/3/5.
//  Copyright © 2023 shusuke. All rights reserved.
//

import Foundation
import KDBluetoothManager

public protocol WiFiSettingViewModelDelegate: AnyObject {
    func wifiSettingViewModel(_ wifiSettingViewModel: WiFiSettingViewModel, canSetWiFi: Bool)
    func wifiSettingViewModelDidSuccessSetting(_ wifiSettingViewModel: WiFiSettingViewModel)
    func wifiSettingViewModelDidFailSetting(_ wifiSettingViewModel: WiFiSettingViewModel)
}

public class WiFiSettingViewModel: NSObject {
    public private(set) var sections: [WiFiSettingSectionType] = [.required, .optional]
    public private(set) var wifiSetting: WiFiSetting

    public weak var delegate: WiFiSettingViewModelDelegate?

    private let bluetoothManager = BluetoothManager.shared

    public init(selectedSSID: String) {
        wifiSetting = WiFiSetting(ssid: selectedSSID, password: "")
        super.init()
        bluetoothManager.delegate = self
    }

    public func sectionRows(section: Int) -> Int {
        let section = sections[section]
        switch section {
        case .required:
            return section.rows.count
        case .optional:
            return section.rows.count
        }
    }

    public func setupWiFi() {
        bluetoothManager.writeCommand(.writeWiFiSetting(wifiSetting))
    }

    public func updateWiFiSetting(ssid: String) {
        wifiSetting.ssid = ssid
    }

    public func updateWiFiSetting(password: String) {
        wifiSetting.password = password
    }

    public func validateWiFiSetting() -> Bool {
        !wifiSetting.ssid.isEmpty && !wifiSetting.password.isEmpty
    }
}

// MARK: - BluetoothManagerDelegate

extension WiFiSettingViewModel: BluetoothManagerDelegate {
    public func bluetoothManager(_ bluetoothManager: KDBluetoothManager.BluetoothManager, isConnected: Bool) {}
    public func bluetoothManagerDidDiscovered(_ bluetoothManager: KDBluetoothManager.BluetoothManager) {}
    public func bluetoothManagerDidConnected(_ bluetoothManager: KDBluetoothManager.BluetoothManager) {}

    public func bluetoothManagerDidReceivedValue(_ bluetoothManager: KDBluetoothManager.BluetoothManager, message: String) {
        guard let completionMessage = BluetoothParser.decodeBluetoothCompletion(message)?.getBluetoothCompletion() else {
            return
        }

        switch completionMessage {
        case .wifiSettingSuccess:
            delegate?.wifiSettingViewModelDidSuccessSetting(self)
        case .wifiSettingFail:
            delegate?.wifiSettingViewModelDidFailSetting(self)
        default:
            break
        }
    }
}
