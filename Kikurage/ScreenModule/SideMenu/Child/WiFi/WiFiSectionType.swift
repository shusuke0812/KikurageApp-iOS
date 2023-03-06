//
//  WiFiSectionType.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2023/03/06.
//  Copyright © 2023 shusuke. All rights reserved.
//

import Foundation

enum WiFiSectionType {
    case device

    var title: String {
        switch self {
        case .device:
            return R.string.localizable.side_menu_wifi_select_device_section_title()
        }
    }
}
