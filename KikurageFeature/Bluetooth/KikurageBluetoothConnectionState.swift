//
//  KikurageBluetoothConnectState.swift
//  KikurageFeature
//
//  Created by Shusuke Ota on 2023/03/08.
//  Copyright © 2023 shusuke. All rights reserved.
//

import Foundation

public enum KikurageBluetoothConnectionState {
    case connect
    case fail(Error?)
    case disconnect(Error?)
}
