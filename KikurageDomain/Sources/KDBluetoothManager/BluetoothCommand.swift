//
//  KikurageBluetoothCommand.swift
//  KikurageFeature
//
//  Created by Shusuke Ota on 2023/03/18.
//  Copyright © 2023 shusuke. All rights reserved.
//

import CoreBluetooth
import Foundation

public enum BluetoothCommand {
    case writeStopWiFiScan
    case writeStartWiFiScan
    case writeWiFiSetting(WiFiSetting)

    public var valueJsonData: Data? {
        switch self {
        case .writeStartWiFiScan:
            let command = WiFiScan(isStop: false)
            return BluetoothParser.encodeBluetootCommand(command)
        case .writeStopWiFiScan:
            let command = WiFiScan(isStop: true)
            return BluetoothParser.encodeBluetootCommand(command)
        case .writeWiFiSetting(let wifiSetting):
            return BluetoothParser.encodeBluetootCommand(wifiSetting)
        }
    }
}
