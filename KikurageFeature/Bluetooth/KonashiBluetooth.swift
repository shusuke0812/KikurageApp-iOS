//
//  KikurageBluetooth.swift
//  KikurageFeature
//
//  Created by Shusuke Ota on 2022/4/22.
//  Copyright © 2022 shusuke. All rights reserved.
//

import Foundation
import konashi_ios_sdk

public protocol KonashiBluetoothDelegate: AnyObject {
    func konashiBluetooth(_ konashiBluetooth: KonashiBluetooth, didUpdated rssi: Int32)
}

public class KonashiBluetooth: NSObject {
    private var readRSSITimer: Timer?
    public weak var delegate: KonashiBluetoothDelegate?

    override public init() {
        Konashi.shared().readyHandler = { () -> Void in
            Konashi.pinMode(KonashiDigitalIOPin.LED2, mode: KonashiPinMode.output)
            Konashi.digitalWrite(KonashiDigitalIOPin.LED2, value: KonashiLevel.high)
        }
    }

    deinit {
        readRSSITimer = nil
    }

    public func find() {
        Konashi.find()
    }

    // MARK: - RSSI
    public func readRSSI() {
        // read request
        readRSSITimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            Konashi.signalStrengthReadRequest()
        }
        // read completion observer
        Konashi.shared().signalStrengthDidUpdateHandler = { [weak self] rssi in
            guard let self = self else { return }
            self.delegate?.konashiBluetooth(self, didUpdated: rssi)
        }
    }
}
