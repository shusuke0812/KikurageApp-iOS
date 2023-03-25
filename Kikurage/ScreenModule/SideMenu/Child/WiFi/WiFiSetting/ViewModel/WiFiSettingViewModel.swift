//
//  WiFiSettingViewModel.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2023/3/5.
//  Copyright © 2023 shusuke. All rights reserved.
//

import Foundation
import KikurageFeature
import UIKit.UITableView

class WiFiSettingViewModel: NSObject {
    private(set) var sections: [WiFiSettingSectionType] = [.required, .optional]

    private var wifiSetting: KikurageWiFiSetting

    init(selectedSSID: String) {
        wifiSetting = KikurageWiFiSetting(ssid: selectedSSID, password: "")
        super.init()
    }
}

// MARK: - UITableViewDataSource

extension WiFiSettingViewModel: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        sections[section].title
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = sections[section]
        switch section {
        case .required:
            return section.rows.count
        case .optional:
            return section.rows.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
    func wifiSettingTableViewCell(_ wifiSettingTableViewCell: WiFiSettingTableViewCell, didEnter text: String) {
        switch wifiSettingTableViewCell.type {
        case .ssid:
            wifiSetting.ssid = text
        case .password:
            wifiSetting.password = text
        case .activeScan, .security:
            break
        }
    }
}
