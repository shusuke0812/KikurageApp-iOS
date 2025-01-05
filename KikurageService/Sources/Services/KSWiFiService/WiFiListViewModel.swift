//
//  WiFiListViewModel.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2023/3/5.
//  Copyright © 2023 shusuke. All rights reserved.
//

import KDRepository
import KDEntity
import KSFeatures
import Foundation

public protocol WiFiListViewModelDelegate: AnyObject {
    func viewModelUpdateWiFiList(_ wifiListViewModel: WiFiListViewModel)
}

public class WiFiListViewModel: NSObject {
    public private(set) var sections: [WiFiListSectionType] = [.spec, .enterWifi, .selectWifi]
    public private(set) var wifiList = KikurageWiFiList()
    public let bluetoothPeripheral: KikurageBluetoothPeripheral
    
    public weak var delegate: WiFiListViewModelDelegate?

    private let bluetoothManager = KikurageBluetoothManager.shared

    public init(bluetoothPeripheral: KikurageBluetoothPeripheral) {
        self.bluetoothPeripheral = bluetoothPeripheral
        super.init()
        bluetoothManager.peripheralDelegate = self
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

// MARK: - KikurageBluetoothPeripheralMangerDelegate

extension WiFiListViewModel: KikurageBluetoothPeripheralMangerDelegate {
    public func bluetoothManager(_ kikurageBluetoothManager: KikurageBluetoothManager, error: Error) {}

    public func bluetoothManager(_ kikurageBluetoothManager: KikurageBluetoothManager, didUpdateFor state: KikurageBluetoothPeripheralState) {}

    public func bluetoothManager(_ kikurageBluetoothManager: KikurageBluetoothManager, message: String) {
        guard let wifi = KikurageBluetoothParser.decodeWiFi(message) else {
            return
        }
        wifiList.addElement(wifi: wifi)

        if wifi.isLastCount() {
            delegate?.viewModelUpdateWiFiList(self)
        }
    }
}
