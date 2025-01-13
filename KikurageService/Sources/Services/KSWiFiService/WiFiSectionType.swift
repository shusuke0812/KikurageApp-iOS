//
//  WiFiSectionType.swift
//  KikurageService
//
//  Created by Shusuke Ota on 2023/03/06.
//  Copyright © 2023 shusuke. All rights reserved.
//

import Foundation
import KDBluetoothManager

public enum WiFiSelectDeviceSectionType {
    case device

    public var title: String {
        switch self {
        case .device:
            return R.LocalizableString.wifiSelectDeviceSectionTitle
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
            return R.LocalizableString.wifiSpecSectionTitle
        case .enterWifi:
            return R.LocalizableString.wifiEnterWifiSectionTitle
        case .selectWifi:
            return R.LocalizableString.wifiSelectWifiSectionTitle
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
                return R.LocalizableString.wifiSpecSectionDeviceNameRowTitle
            case .deviceID:
                return R.LocalizableString.wifiSpecSectionDeviceIDRowTitle
            case .rssi:
                return R.LocalizableString.wifiSpecSectionRssiRowTitle
            case .enterWifi:
                return R.LocalizableString.wifiSpecSectionWifiEnterRowTitle
            }
        }

        public func getSpecTitle(bluetoothPeripheral: BluetoothPeripheral) -> String {
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
            return R.LocalizableString.wifiSettingSectionRequiredTitle
        case .optional:
            return R.LocalizableString.wifiSettingSectionOptionalTitle
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
                return R.LocalizableString.wifiSettingSectionPasswordRowTitle
            case .activeScan:
                return R.LocalizableString.wifiSettingSectionActiveScanRowTitle
            case .security:
                return R.LocalizableString.wifiSettingSectionSecurityRowTitle
            }
        }
    }
}
