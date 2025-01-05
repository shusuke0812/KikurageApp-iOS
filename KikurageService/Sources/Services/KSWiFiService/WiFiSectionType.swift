//
//  WiFiSectionType.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2023/03/06.
//  Copyright © 2023 shusuke. All rights reserved.
//

import KSFeatures
import Foundation

public enum WiFiSelectDeviceSectionType {
    case device

    public var title: String {
        switch self {
        case .device:
            return R.string.localizable.side_menu_wifi_select_device_section_title()
        }
    }
}

public enum WiFiListSectionType {
    case spec
    case enterWifi
    case selectWifi

    public var title: String {
        switch self {
        case .spec:
            return R.string.localizable.side_menu_wifi_spec_section_title()
        case .enterWifi:
            return R.string.localizable.side_menu_wifi_enter_wifi_section_title()
        case .selectWifi:
            return R.string.localizable.side_menu_wifi_select_wifi_section_title()
        }
    }

    public var rows: [SectionRowType] {
        switch self {
        case .spec:
            return [.deviceName, .deviceID, .rssi]
        case .enterWifi:
            return [.enterWifi]
        case .selectWifi:
            return []
        }
    }

    public enum SectionRowType {
        case deviceName
        case deviceID
        case rssi
        case enterWifi

        public var title: String {
            switch self {
            case .deviceName:
                return R.string.localizable.side_menu_wifi_spec_section_device_name_row_title()
            case .deviceID:
                return R.string.localizable.side_menu_wifi_spec_section_device_id_row_title()
            case .rssi:
                return R.string.localizable.side_menu_wifi_spec_section_rssi_row_title()
            case .enterWifi:
                return R.string.localizable.side_menu_wifi_spec_section_wifi_enter_row_title()
            }
        }

        public func getSpecTitle(bluetoothPeripheral: KikurageBluetoothPeripheral) -> String {
            switch self {
            case .deviceName:
                return bluetoothPeripheral.deviceName
            case .deviceID:
                let idString = String(bluetoothPeripheral.uuid.uuidString.prefix(14)) + "****"
                return idString
            case .rssi:
                return "\(bluetoothPeripheral.rssi)"
            case .enterWifi:
                return ""
            }
        }
    }
}

public enum WiFiSettingSectionType {
    case required
    case optional

    public var title: String {
        switch self {
        case .required:
            return R.string.localizable.side_menu_wifi_setting_section_required_title()
        case .optional:
            return R.string.localizable.side_menu_wifi_setting_section_optional_title()
        }
    }

    public var rows: [SectionRowType] {
        switch self {
        case .required:
            return [.ssid, .password]
        case .optional:
            return [.activeScan, .security]
        }
    }

    public enum SectionRowType {
        case ssid
        case password
        case activeScan
        case security

        public var title: String {
            switch self {
            case .ssid:
                return "SSID"
            case .password:
                return R.string.localizable.side_menu_wifi_setting_section_password_row_title()
            case .activeScan:
                return R.string.localizable.side_menu_wifi_setting_section_active_scan_row_title()
            case .security:
                return R.string.localizable.side_menu_wifi_setting_section_security_row_title()
            }
        }
    }
}
