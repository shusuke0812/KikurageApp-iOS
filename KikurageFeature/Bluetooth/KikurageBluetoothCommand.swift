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

    var typeString: String {
        switch self {
        case .writeStopWiFiScan:
            return "stop_wifi_scan"
        }
    }

    public var typeJsonData: Data? {
        switch self {
        case .writeStopWiFiScan:
            let command = BluetoothCommand(command: typeString)
            return KikurageBluetoothParser.encodeBluetootCommand(command)
        }
    }

    public var valueJsonData: Data? {
        switch self {
        case .writeStopWiFiScan:
            let command = BluetoothStopWiFiScanCommand()
            return KikurageBluetoothParser.encodeBluetootCommand(command)
        }
    }
}

struct BluetoothCommand: Encodable {
    private let command: String

    init(command: String) {
        self.command = command
    }
}

struct BluetoothStopWiFiScanCommand: Encodable {
    private let command: Bool
    
    init() {
        self.command = true
    }
}
