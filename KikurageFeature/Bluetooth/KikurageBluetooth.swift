//
//  KikurageBluetooth.swift
//  KikurageFeature
//
//  Created by Shusuke Ota on 2022/4/22.
//  Copyright © 2022 shusuke. All rights reserved.
//

import Foundation
import konashi_ios_sdk

public class KikurageBluetooth: NSObject {
    override init() {
        Konashi.shared().readyHandler = { () -> Void in
            Konashi.pinMode(KonashiDigitalIOPin.LED2, mode: KonashiPinMode.output)
            Konashi.digitalWrite(KonashiDigitalIOPin.LED2, value: KonashiLevel.high)
        }
    }
    
    public func find() {
        Konashi.find()
    }
}
