//
//  WiFiListViewModel.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2023/3/5.
//  Copyright © 2023 shusuke. All rights reserved.
//

import Foundation
import KDBluetoothManager

protocol WiFiListViewModelDelegate: AnyObject {
    func viewModelUpdateWiFiList(_ wifiListViewModel: WiFiListViewModel)
}

class WiFiListViewModel: NSObject {
    weak var delegate: WiFiListViewModelDelegate?
    let state = WiFiListState()

    private var wifiList = WiFiList()
    private let bluetoothManager = BluetoothManager.shared

    override init() {
        super.init()
        setupStaticState()
    }

    func bluetoothDelegate() {
        bluetoothManager.delegate = self
    }

    func startWiFiScan() {
        state.isScanning = true
        bluetoothManager.writeCommand(.writeStartWiFiScan)
    }

    func stopWiFiScan() {
        bluetoothManager.writeCommand(.writeStopWiFiScan)
    }

    func disconnectPeripheral() {
        bluetoothManager.disconnect()
    }
}

// MARK: - State Setting

extension WiFiListViewModel {
    private func setupStaticState() {
        state.specSectionTitle = WiFiListSectionType.spec.title
        state.enterWifiSectionTitle = WiFiListSectionType.enterWifi.title
        state.selectWifiSectionTitle = WiFiListSectionType.selectWifi.title

        state.enterWifiItems = WiFiListSectionType.enterWifi.rows.map { row in
            WiFiListSelectableItem(id: row.title, title: row.title, ssid: "")
        }

        guard let selectedPeripheral = bluetoothManager.selectedPeripheral else {
            return
        }
        state.specItems = WiFiListSectionType.spec.rows.map { row in
            WiFiListSpecItem(
                id: row.title,
                title: row.title,
                stateTitle: row.getSpecTitle(bluetoothPeripheral: selectedPeripheral)
            )
        }
    }
}

// MARK: - BluetoothManagerDelegate

extension WiFiListViewModel: BluetoothManagerDelegate {
    func bluetoothManager(_ bluetoothManager: BluetoothManager, isConnected: Bool) {}
    func bluetoothManagerDidDiscovered(_ bluetoothManager: KDBluetoothManager.BluetoothManager) {}
    func bluetoothManagerDidConnected(_ bluetoothManager: KDBluetoothManager.BluetoothManager) {}

    func bluetoothManagerDidReceivedValue(_ bluetoothManager: KDBluetoothManager.BluetoothManager, message: String) {
        guard let wifi = BluetoothParser.decodeWiFi(message) else {
            return
        }
        wifiList.addElement(wifi: wifi)
        state.selectWifiItems = wifiList.list.map { wifi in
            WiFiListSelectableItem(id: wifi.ssid, title: wifi.ssid, ssid: wifi.ssid)
        }

        if wifi.isLastCount() {
            state.isScanning = false
            delegate?.viewModelUpdateWiFiList(self)
        }
    }
}
