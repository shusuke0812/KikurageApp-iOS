//
//  WiFiListViewModel.swift
//  KikurageService
//
//  Created by Shusuke Ota on 2023/3/5.
//  Copyright © 2023 shusuke. All rights reserved.
//

import Foundation
import KDBluetoothManager

public protocol WiFiListViewModelDelegate: AnyObject {
    func viewModelUpdateWiFiList(_ wifiListViewModel: WiFiListViewModel)
}

public class WiFiListViewModel: NSObject {
    public weak var delegate: WiFiListViewModelDelegate?
    public let state = WiFiListState()

    private var wifiList = WiFiList()
    private let bluetoothManager = BluetoothManager.shared

    override public init() {
        super.init()
        setupStaticState()
    }

    public func bluetoothDelegate() {
        bluetoothManager.delegate = self
    }

    public func startWiFiScan() {
        state.isScanning = true
        bluetoothManager.writeCommand(.writeStartWiFiScan)
    }

    public func stopWiFiScan() {
        bluetoothManager.writeCommand(.writeStopWiFiScan)
    }

    public func disconnectPeripheral() {
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
    public func bluetoothManager(_ bluetoothManager: BluetoothManager, isConnected: Bool) {}
    public func bluetoothManagerDidDiscovered(_ bluetoothManager: KDBluetoothManager.BluetoothManager) {}
    public func bluetoothManagerDidConnected(_ bluetoothManager: KDBluetoothManager.BluetoothManager) {}

    public func bluetoothManagerDidReceivedValue(_ bluetoothManager: KDBluetoothManager.BluetoothManager, message: String) {
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
