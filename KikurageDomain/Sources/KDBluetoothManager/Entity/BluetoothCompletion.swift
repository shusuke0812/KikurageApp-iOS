//
//  BluetoothCompletion.swift
//  KikurageDomain
//
//  Created by Shusuke Ota on 2023/03/28.
//  Copyright © 2023 shusuke. All rights reserved.
//

import Foundation

public struct BluetoothCompletionMessage: Decodable {
    let type: String
    let description: String

    enum CodingKeys: String, CodingKey {
        case type
        case description
    }

    public func getBluetoothCompletion() -> BluetoothCompletion {
        if type == "success" {
            switch description.lowercased() {
            case "wifi setting success":
                return .wifiSettingSuccess
            default:
                return .notFound
            }
        } else {
            switch description.lowercased() {
            case "wifi setting fail":
                return .wifiSettingFail
            default:
                return .notFound
            }
        }
    }
}

public enum BluetoothCompletion {
    case wifiSettingSuccess
    case wifiSettingFail
    case notFound
}
