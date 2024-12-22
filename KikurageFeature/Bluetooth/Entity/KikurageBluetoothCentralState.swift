//
//  KikurageBluetoothCentralState.swift
//  KikurageFeature
//
//  Created by Shusuke Ota on 2023/04/09.
//  Copyright © 2023 shusuke. All rights reserved.
//

import CoreBluetooth
import Foundation

public struct KikurageBluetoothCentralState {
    public let value: CBManagerState

    public init(value: CBManagerState) {
        self.value = value
    }
}

public enum KikurageBluetoothConnectionState {
    case standby
    case connect
    case fail(Error?)
    case disconnect(Error?)
}

public enum KikurageBluetoothPeripheralState {
    case standby
    case didDiscoverCharacteristic
}
