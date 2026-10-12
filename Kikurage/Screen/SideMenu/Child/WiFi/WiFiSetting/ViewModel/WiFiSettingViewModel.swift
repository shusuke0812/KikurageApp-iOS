//
//  WiFiSettingViewModel.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2023/3/5.
//  Copyright © 2023 shusuke. All rights reserved.
//

import Foundation
import KDBluetoothManager

protocol WiFiSettingViewModelDelegate: AnyObject {
    func wifiSettingViewModelDidSuccessSetting(_ wifiSettingViewModel: WiFiSettingViewModel)
    func wifiSettingViewModelDidFailSetting(_ wifiSettingViewModel: WiFiSettingViewModel)
}

class WiFiSettingViewModel: NSObject {
    weak var delegate: WiFiSettingViewModelDelegate?
    let state = WiFiSettingState()

    private let bluetoothManager = BluetoothManager.shared

    init(selectedSSID: String) {
        super.init()
        state.ssid = selectedSSID
    }

    func bluetoothDelegate() {
        bluetoothManager.delegate = self
    }

    func setupWiFi() {
        state.isSettingUp = true
        let wifiSetting = WiFiSetting(ssid: state.ssid, password: state.password)
        bluetoothManager.writeCommand(.writeWiFiSetting(wifiSetting))
    }
}

// MARK: - BluetoothManagerDelegate

extension WiFiSettingViewModel: BluetoothManagerDelegate {
    func bluetoothManager(_ bluetoothManager: KDBluetoothManager.BluetoothManager, isConnected: Bool) {}
    func bluetoothManagerDidDiscovered(_ bluetoothManager: KDBluetoothManager.BluetoothManager) {}
    func bluetoothManagerDidConnected(_ bluetoothManager: KDBluetoothManager.BluetoothManager) {}

    func bluetoothManagerDidReceivedValue(_ bluetoothManager: KDBluetoothManager.BluetoothManager, message: String) {
        guard let completionMessage = BluetoothParser.decodeBluetoothCompletion(message)?.getBluetoothCompletion() else {
            return
        }

        state.isSettingUp = false
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
