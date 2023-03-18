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

    var valueString: String {
        switch self {
        case .writeStopWiFiScan:
            return "stop_wifi_scan"
        }
    }

    public var valueData: Data? {
        let command = BluetoothCommand(command: valueString)
        return KikurageBluetoothParser.encodeBluetootCommand(command)
    }
}

struct BluetoothCommand: Encodable {
    private let command: String

    init(command: String) {
        self.command = command
    }
}
