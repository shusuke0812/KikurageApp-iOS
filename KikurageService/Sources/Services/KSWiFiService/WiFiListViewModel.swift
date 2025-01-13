//
//  WiFiListViewModel.swift
//  Kikurage
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
    public private(set) var sections: [WiFiListSectionType] = [.spec, .enterWifi, .selectWifi]
    public private(set) var wifiList = WiFiList()
    
    public var selectedPeripheral: BluetoothPeripheral? {
        bluetoothManager.selectedPeripheral
    }
    
    public weak var delegate: WiFiListViewModelDelegate?
    
    private let bluetoothManager = BluetoothManager.shared

    public override init() {
        super.init()
        bluetoothManager.delegate = self
    }

    public func sectionRows(section: Int) -> Int {
        switch sections[section] {
        case .spec, .enterWifi:
            return sections[section].rows.count
        case .selectWifi:
            return wifiList.list.count
        }
    }

    public func getSelectedSSID(indexPath: IndexPath) -> String {
        let section = sections[indexPath.section]
        switch section {
        case .spec, .enterWifi:
            return ""
        case .selectWifi:
            return wifiList.list[indexPath.row].ssid
        }
    }

    public func startWiFiScan() {
        bluetoothManager.writeCommand(.writeStartWiFiScan)
    }

    public func stopWiFiScan() {
        bluetoothManager.writeCommand(.writeStopWiFiScan)
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

        if wifi.isLastCount() {
            delegate?.viewModelUpdateWiFiList(self)
        }
    }
}
