//
//  KikurageBLESignal.swift
//  KikurageFeature
//
//  Created by Shusuke Ota on 2023/03/06.
//  Copyright © 2023 shusuke. All rights reserved.
//

import UIKit

public enum KikurageBluetoothSignal {
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
            return ResorceManager.getImage(name: "signal-lost")
        case .weak:
            return ResorceManager.getImage(name: "signal-weak")
        case .fair:
            return ResorceManager.getImage(name: "signal-fair")
        case .good:
            return ResorceManager.getImage(name: "signal-good")
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
