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

    public var valueJsonData: Data? {
        switch self {
        case .writeStopWiFiScan:
            let command = BluetoothStopWiFiScanCommand()
            return KikurageBluetoothParser.encodeBluetootCommand(command)
        }
    }
}

struct BluetoothStopWiFiScanCommand: Encodable {
    private let command: Bool
    
    init() {
        self.command = true
    }
}
