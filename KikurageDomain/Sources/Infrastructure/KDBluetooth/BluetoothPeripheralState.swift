//
//  BluetoothPeripheralState.swift
//  KikurageDomain
//
//  Created by Shusuke Ota on 2025/1/12.
//

import CoreBluetooth
import Foundation

public enum BluetoothPeripheralState {
    case standby
    case didDiscoverCharacteristic([CBCharacteristic]?)
}
