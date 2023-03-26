//
//  KikurageBluetoothCommand.swift
//  KikurageFeature
//
//  Created by Shusuke Ota on 2023/03/18.
//  Copyright © 2023 shusuke. All rights reserved.
//

import Foundation

public enum KikurageBluetoothCommand {
    case writeStopWiFiScan
    case writeStartWiFiScan
    case writeWiFiSetting(KikurageWiFiSetting)

    public var valueJsonData: Data? {
        switch self {
        case .writeStartWiFiScan:
            let command = KikurageWiFiScan(isStop: false)
            return KikurageBluetoothParser.encodeBluetootCommand(command)
        case .writeStopWiFiScan:
            let command = KikurageWiFiScan(isStop: true)
            return KikurageBluetoothParser.encodeBluetootCommand(command)
        case .writeWiFiSetting(let wifiSetting):
            return KikurageBluetoothParser.encodeBluetootCommand(wifiSetting)
        }
    }
}
