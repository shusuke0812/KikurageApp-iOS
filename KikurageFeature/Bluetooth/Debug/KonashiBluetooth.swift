//
//  KikurageBluetooth.swift
//  KikurageFeature
//
//  Created by Shusuke Ota on 2022/4/22.
//  Copyright © 2022 shusuke. All rights reserved.
//

// [ Konashi Document ]
// repos: https://github.com/YUKAI/konashi-ios-sdk
// get started: http://konashi.ux-xu.com/getting_started/
// doc: http://konashi.ux-xu.com/documents/

import Foundation
import konashi_ios_sdk

public protocol KonashiBluetoothDelegate: AnyObject {
    func konashiBluetooth(_ konashiBluetooth: KonashiBluetooth, didUpdated rssi: Int32)
    func konashiBluetoothDidUpdatedPIOInput(_ konashiBluetooth: KonashiBluetooth)
    func konashiBluetoothDisconnected(_ konashiBluetooth: KonashiBluetooth)
}

/**
Bluetooth sample

This is sample code about Bluetooth, which is shown how to find HW and to get its RSSI.
It is used Konashi for HW.
*/
public class KonashiBluetooth: NSObject {
    private var readRSSITimer: Timer?
    private var currentLED: KonashiDigitalIOPin?

    public weak var delegate: KonashiBluetoothDelegate?

    override public init() {
        super.init()

        readyHandler()
        pioInputUpdatedHandler()
        disconnectedHandler()
    }

    deinit {
        readRSSITimer = nil
        Konashi.shared().signalStrengthDidUpdateHandler = nil
    }

    public func find() {
        Konashi.find()
    }

    private func readyHandler() {
        Konashi.shared().readyHandler = { [weak self] () -> Void in
            self?.flashLED(KonashiDigitalIOPin.LED2)
        }
    }

    private func disconnectedHandler() {
        Konashi.shared().disconnectedHandler = { [weak self] in
            guard let self = self else { return }
            self.delegate?.konashiBluetoothDisconnected(self)
        }
    }

    private func pioInputUpdatedHandler() {
        Konashi.shared().digitalInputDidChangeValueHandler = { [weak self] pin, value in
            guard let self = self else { return }
            if (pin == .S1) && (value == 1) {
                self.delegate?.konashiBluetoothDidUpdatedPIOInput(self)
            }
        }
    }

    // MARK: - LED

    public func flashLED(_ led: KonashiDigitalIOPin) {
        Konashi.pinMode(led, mode: KonashiPinMode.output)
        Konashi.digitalWrite(led, value: KonashiLevel.high)
    }

    public func turnOffAll() {
        Konashi.pinModeAll(KonashiPinMode.output.rawValue)
        Konashi.digitalWriteAll(KonashiLevel.high.rawValue)
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
