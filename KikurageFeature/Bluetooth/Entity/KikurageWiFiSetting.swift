//
//  KikurageWiFiSetting.swift
//  KikurageFeature
//
//  Created by Shusuke Ota on 2023/03/25.
//  Copyright © 2023 shusuke. All rights reserved.
//

import Foundation

public struct KikurageWiFiSetting {
    public var ssid: String
    public var password: String

    public init(ssid: String, password: String) {
        self.ssid = ssid
        self.password = password
    }
    // TODO: Convert password to AES256
}
