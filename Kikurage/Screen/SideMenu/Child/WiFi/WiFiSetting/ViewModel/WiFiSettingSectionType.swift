//
//  WiFiSettingSectionType.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2023/03/06.
//  Copyright © 2023 shusuke. All rights reserved.
//

import Foundation

enum WiFiSettingSectionType {
    case required
    case optional

    var title: String {
        switch self {
        case .required:
            return R.string.localizable.side_menu_wifi_setting_section_required_title()
        case .optional:
            return R.string.localizable.side_menu_wifi_setting_section_optional_title()
        }
    }

    var rows: [SectionRowType] {
        switch self {
        case .required:
            return [.ssid, .password]
        case .optional:
            return [.activeScan, .security]
        }
    }

    enum SectionRowType {
        case ssid
        case password
        case activeScan
        case security

        var title: String {
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
