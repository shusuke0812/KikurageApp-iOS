//
//  BluetoothConnectionState.swift
//  KikurageDomain
//
//  Created by Shusuke Ota on 2025/1/12.
//

import Foundation

public enum BluetoothConnectionState {
    case standby
    case connect
    case fail(Error?)
    case disconnect(Error?)
}
