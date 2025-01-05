//
//  WiFiSettingViewModel.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2023/3/5.
//  Copyright © 2023 shusuke. All rights reserved.
//

import KSFeatures
import Foundation
import UIKit.UITableView

public protocol WiFiSettingViewModelDelegate: AnyObject {
    func wifiSettingViewModel(_ wifiSettingViewModel: WiFiSettingViewModel, canSetWiFi: Bool)
    func wifiSettingViewModelDidSuccessSetting(_ wifiSettingViewModel: WiFiSettingViewModel)
    func wifiSettingViewModelDidFailSetting(_ wifiSettingViewModel: WiFiSettingViewModel)
}

public class WiFiSettingViewModel: NSObject {
    private(set) var sections: [WiFiSettingSectionType] = [.required, .optional]

    private let bluetoothManager = KikurageBluetoothManager.shared
    private var wifiSetting: KikurageWiFiSetting

    public weak var delegate: WiFiSettingViewModelDelegate?

    public init(selectedSSID: String) {
        wifiSetting = KikurageWiFiSetting(ssid: selectedSSID, password: "")
        super.init()
        bluetoothManager.peripheralDelegate = self
    }

    public func setupWiFi() {
        bluetoothManager.writeCommand(.writeWiFiSetting(wifiSetting))
    }

    private func validateWiFiSetting() -> Bool {
        !wifiSetting.ssid.isEmpty && !wifiSetting.password.isEmpty
    }
}

// MARK: - UITableViewDataSource

extension WiFiSettingViewModel: UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }

    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        sections[section].title
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = sections[section]
        switch section {
        case .required:
            return section.rows.count
        case .optional:
            return section.rows.count
        }
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = sections[indexPath.section]
        let row = section.rows[indexPath.row]
        switch section {
        case .required:
            let cell = tableView.dequeueReusableCell(withIdentifier: "WiFiSettingTableViewCell", for: indexPath) as! WiFiSettingTableViewCell // swiftlint:disable:this force_cast
            cell.updateComponent(title: row.title)
            cell.type = row
            cell.delegate = self
            if row == .ssid {
                cell.updateComponent(textFieldText: wifiSetting.ssid)
            }
            return cell
        case .optional:
            let cell = tableView.dequeueReusableCell(withIdentifier: "WiFiListTableViewCell", for: indexPath) as! WiFiListTableViewCell // swiftlint:disable:this force_cast
            cell.updateComponent(title: row.title)
            return cell
        }
    }
}

// MARK: - WiFiSettingTableViewCellDelegate

extension WiFiSettingViewModel: WiFiSettingTableViewCellDelegate {
    public func wifiSettingTableViewCell(_ wifiSettingTableViewCell: WiFiSettingTableViewCell, didEnter text: String) {
        switch wifiSettingTableViewCell.type {
        case .ssid:
            wifiSetting.ssid = text
        case .password:
            wifiSetting.password = text
        case .activeScan, .security:
            break // never called
        }
        delegate?.wifiSettingViewModel(self, canSetWiFi: validateWiFiSetting())
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
