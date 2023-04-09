//
//  KikurageCentralManagerState.swift
//  KikurageFeature
//
//  Created by Shusuke Ota on 2023/04/09.
//  Copyright © 2023 shusuke. All rights reserved.
//

import CoreBluetooth
import Foundation

public struct KikurageBluetoothState {
    public let centralManagerState: CBManagerState

    public init(centralManagerState: CBManagerState) {
        self.centralManagerState = centralManagerState
    }
}
