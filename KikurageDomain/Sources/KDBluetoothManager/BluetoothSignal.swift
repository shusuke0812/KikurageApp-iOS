//
//  BluetoothSignal.swift
//  KikurageDomain
//
//  Created by Shusuke Ota on 2023/03/06.
//  Copyright © 2023 shusuke. All rights reserved.
//

import UIKit

public enum BluetoothSignal {
    case lost
    case weak
    case fair
    case good

    public init() {
        self = .lost
    }

    public var image: UIImage? {
        switch self {
        case .lost:
            return R.Image.signalLost
        case .weak:
            return R.Image.signalWeak
        case .fair:
            return R.Image.signalFair
        case .good:
            return R.Image.signalGood
        }
    }

    // NOTE: Based on experiment value using LightBlue App.
    public static func getSignal(rssi: Int) -> Self {
        let _rssi = abs(rssi)
        if _rssi < 45 {
            return .good
        } else if _rssi < 60 {
            return .fair
        } else if _rssi < 80 {
            return .weak
        } else {
            return .lost
        }
    }
}
