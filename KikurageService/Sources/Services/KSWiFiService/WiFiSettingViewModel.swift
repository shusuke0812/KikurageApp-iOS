//
//  WiFiSettingViewModel.swift
//  KikurageService
//
//  Created by Shusuke Ota on 2023/3/5.
//  Copyright © 2023 shusuke. All rights reserved.
//

import Foundation
import KDBluetoothManager

public protocol WiFiSettingViewModelDelegate: AnyObject {
    func wifiSettingViewModelDidSuccessSetting(_ wifiSettingViewModel: WiFiSettingViewModel)
    func wifiSettingViewModelDidFailSetting(_ wifiSettingViewModel: WiFiSettingViewModel)
}

public class WiFiSettingViewModel: NSObject {
    public weak var delegate: WiFiSettingViewModelDelegate?
    public let state = WiFiSettingState()

    private let bluetoothManager = BluetoothManager.shared

    public init(selectedSSID: String) {
        super.init()
        state.ssid = selectedSSID
    }

    public func bluetoothDelegate() {
        bluetoothManager.delegate = self
    }

    public func setupWiFi() {
        state.isSettingUp = true
        let wifiSetting = WiFiSetting(ssid: state.ssid, password: state.password)
        bluetoothManager.writeCommand(.writeWiFiSetting(wifiSetting))
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
