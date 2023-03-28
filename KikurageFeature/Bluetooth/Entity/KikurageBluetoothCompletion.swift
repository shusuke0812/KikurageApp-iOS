//
//  KikurageBluetoothCompletion.swift
//  KikurageFeature
//
//  Created by Shusuke Ota on 2023/03/28.
//  Copyright © 2023 shusuke. All rights reserved.
//

import Foundation

public struct KikurageBluetoothCompletionMessage: Decodable {
    let type: String
    let message: String

    enum CodingKeys: String, CodingKey {
        case type
        case message
    }

    public func getKikurageBluetoothCompletion() -> KikurageBluetoothCompletion {
        if type == "success" {
            switch message.lowercased() {
            case "wifi setting success":
                return .wifiSettingSuccess
            default:
                return .notFound
            }
        } else {
            switch message.lowercased() {
            case "wifi setting fail":
                return .wifiSettingFail
            default:
                return .notFound
            }
        }
    }
}

public enum KikurageBluetoothCompletion {
    case wifiSettingSuccess
    case wifiSettingFail
    case notFound
}
