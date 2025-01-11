//
//  WiFiSettingViewModel.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2023/3/5.
//  Copyright © 2023 shusuke. All rights reserved.
//

import Foundation
import KSSBluetooth

public protocol WiFiSettingViewModelDelegate: AnyObject {
    func wifiSettingViewModel(_ wifiSettingViewModel: WiFiSettingViewModel, canSetWiFi: Bool)
    func wifiSettingViewModelDidSuccessSetting(_ wifiSettingViewModel: WiFiSettingViewModel)
    func wifiSettingViewModelDidFailSetting(_ wifiSettingViewModel: WiFiSettingViewModel)
}

public class WiFiSettingViewModel: NSObject {
    public private(set) var sections: [WiFiSettingSectionType] = [.required, .optional]
    public private(set) var wifiSetting: KikurageWiFiSetting

    public weak var delegate: WiFiSettingViewModelDelegate?

    private let bluetoothManager = KikurageBluetoothManager.shared

    public init(selectedSSID: String) {
        wifiSetting = KikurageWiFiSetting(ssid: selectedSSID, password: "")
        super.init()
        bluetoothManager.peripheralDelegate = self
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

// MARK: - KikurageBluetoothPeripheralMangerDelegate

extension WiFiSettingViewModel: KikurageBluetoothPeripheralMangerDelegate {
    public func bluetoothManager(_ kikurageBluetoothManager: KikurageBluetoothManager, didUpdateFor state: KikurageBluetoothPeripheralState) {}

    public func bluetoothManager(_ kikurageBluetoothManager: KikurageBluetoothManager, error: Error) {}

    public func bluetoothManager(_ kikurageBluetoothManager: KikurageBluetoothManager, message: String) {
        guard let completionMessage = KikurageBluetoothParser.decodeBluetoothCompletion(message)?.getKikurageBluetoothCompletion() else {
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
