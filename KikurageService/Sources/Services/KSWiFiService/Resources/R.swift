//
//  R.swift
//  KikurageService
//
//  Created by Shusuke Ota on 2025/1/11.
//

import Foundation

enum R {
    enum LocalizableString {
        static let wifiSelectDeviceSectionTitle = string(localized: "side_menu_wifi_select_device_section_title")
        static let wifiSpecSectionTitle = string(localized: "side_menu_wifi_spec_section_title")
        static let wifiEnterWifiSectionTitle = string(localized: "side_menu_wifi_enter_wifi_section_title")
        static let wifiSelectWifiSectionTitle = string(localized: "side_menu_wifi_select_wifi_section_title")
        static let wifiSpecSectionDeviceNameRowTitle = string(localized: "side_menu_wifi_spec_section_device_name_row_title")
        static let wifiSpecSectionDeviceIDRowTitle = string(localized: "side_menu_wifi_spec_section_device_id_row_title")
        static let wifiSpecSectionRssiRowTitle = string(localized: "side_menu_wifi_spec_section_rssi_row_title")
        static let wifiSpecSectionWifiEnterRowTitle = string(localized: "side_menu_wifi_spec_section_wifi_enter_row_title")
        static let wifiSettingSectionRequiredTitle = string(localized: "side_menu_wifi_setting_section_required_title")
        static let wifiSettingSectionOptionalTitle = string(localized: "side_menu_wifi_setting_section_optional_title")
        static let wifiSettingSectionPasswordRowTitle = string(localized: "side_menu_wifi_setting_section_password_row_title")
        static let wifiSettingSectionActiveScanRowTitle = string(localized: "side_menu_wifi_setting_section_active_scan_row_title")
        static let wifiSettingSectionSecurityRowTitle = string(localized: "side_menu_wifi_setting_section_security_row_title")
    }

    private static func string(localized key: String.LocalizationValue) -> String {
        String(localized: key, bundle: .module)
    }
}
