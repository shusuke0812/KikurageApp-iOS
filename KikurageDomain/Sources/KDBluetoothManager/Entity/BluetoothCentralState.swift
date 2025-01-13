//
//  BluetoothCentralState.swift
//  KikurageFeature
//
//  Created by Shusuke Ota on 2023/04/09.
//  Copyright © 2023 shusuke. All rights reserved.
//

import CoreBluetooth
import Foundation

public struct BluetoothCentralState {
    public let value: CBManagerState

    public init(value: CBManagerState) {
        self.value = value
    }
}
