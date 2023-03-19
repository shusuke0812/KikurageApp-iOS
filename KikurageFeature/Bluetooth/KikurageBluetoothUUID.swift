//
//  KikurageBluetoothUUID.swift
//  KikurageFeature
//
//  Created by Shusuke Ota on 2023/3/5.
//  Copyright © 2023 shusuke. All rights reserved.
//

import CoreBluetooth
import Foundation

public enum KikurageBluetoothUUID {
    public enum LocalName {
        static let debugM5Stack = "kikurage-device-m5-stack"
    }

    public enum Service {
        case m5stack

        var uuidString: String {
            switch self {
            case .m5stack:
                return "65609901-b6ed-45cc-b8af-b4055a9b7666"
            }
        }

        var cbUUID: CBUUID {
            CBUUID(string: uuidString)
        }
    }

    public enum Characteristic {
        case writeToM5Stack
        case readWiFiFromM5Stack
        case debug1
        case debug2

        var uuidString: String {
            switch self {
            case .writeToM5Stack:
                return "65609902-b6ed-45cc-b8af-b4055a9b7666"
            case .readWiFiFromM5Stack:
                return "65609903-b6ed-45cc-b8af-b4055a9b7666"
            case .debug1:
                return "65609904-b6ed-45cc-b8af-b4055a9b7666"
            case .debug2:
                return "65609905-b6ed-45cc-b8af-b4055a9b7666"
            }
        }

        var cbUUID: CBUUID {
            CBUUID(string: uuidString)
        }
    }

    static func configCharactericticCBUUID() -> [CBUUID] {
        [
            Self.Characteristic.writeToM5Stack.cbUUID,
            Self.Characteristic.readWiFiFromM5Stack.cbUUID
        ]
    }
}
