//
//  KikurageBluetoothUUID.swift
//  KikurageFeature
//
//  Created by Shusuke Ota on 2023/3/5.
//  Copyright © 2023 shusuke. All rights reserved.
//

import Foundation

public enum KikurageBluetoothUUID {
    public enum LocalName {
        static let debugM5Stack = "kikurage-device-m5-stack"
    }

    public enum Service {
        static let debugM5Stack = "65609901-b6ed-45cc-b8af-b4055a9b7666"
    }

    public enum Characteristic {
        static let debugM5StackDisplay = "65609902-b6ed-45cc-b8af-b4055a9b7666"
        static let debugM5Stack9AxisX = "65609903-b6ed-45cc-b8af-b4055a9b7666"
        static let debugM5Stack9AxisY = "65609904-b6ed-45cc-b8af-b4055a9b7666"
        static let debugM5Stack9AxisZ = "65609905-b6ed-45cc-b8af-b4055a9b7666"
    }
}
