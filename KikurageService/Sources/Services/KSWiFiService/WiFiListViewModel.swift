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
import UIKit.UITableView

public protocol WiFiListViewModelDelegate: AnyObject {
    func viewModelUpdateWiFiList(_ wifiListViewModel: WiFiListViewModel)
}

public class WiFiListViewModel: NSObject {
    private(set) var sections: [WiFiListSectionType] = [.spec, .enterWifi, .selectWifi]

    private let bluetoothManager = KikurageBluetoothManager.shared
    private let bluetoothPeripheral: KikurageBluetoothPeripheral
    private var wifiList = KikurageWiFiList()

    public weak var delegate: WiFiListViewModelDelegate?

    public init(bluetoothPeripheral: KikurageBluetoothPeripheral) {
        self.bluetoothPeripheral = bluetoothPeripheral
        super.init()
        bluetoothManager.peripheralDelegate = self
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

// MARK: - UITableViewDataSource

extension WiFiListViewModel: UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch sections[section] {
        case .spec, .enterWifi:
            return sections[section].rows.count
        case .selectWifi:
            return wifiList.list.count
        }
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = sections[indexPath.section]
        switch section {
        case .spec:
            let cell = tableView.dequeueReusableCell(withIdentifier: "WiFiListSpecTableViewCell", for: indexPath) as! WiFiListSpecTableViewCell // swiftlint:disable:this force_cast
            cell.updateComponent(title: section.rows[indexPath.row].title)
            cell.updateComponent(stateTitle: section.rows[indexPath.row].getSpecTitle(bluetoothPeripheral: bluetoothPeripheral))
            return cell
        case .enterWifi:
            let cell = tableView.dequeueReusableCell(withIdentifier: "WiFiListTableViewCell", for: indexPath) as! WiFiListTableViewCell // swiftlint:disable:this force_cast
            cell.updateComponent(title: section.rows[indexPath.row].title)
            return cell
        case .selectWifi:
            let cell = tableView.dequeueReusableCell(withIdentifier: "WiFiListTableViewCell", for: indexPath) as! WiFiListTableViewCell // swiftlint:disable:this force_cast
            cell.updateComponent(title: wifiList.getWiFiTitle(indexPath: indexPath))
            return cell
        }
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
