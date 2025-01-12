//
//  KikurageBluetoothManager.swift
//  KikurageFeature
//
//  Created by Shusuke Ota on 2023/1/16.
//  Copyright © 2023 shusuke. All rights reserved.
//

import KDBluetooth
import CoreBluetooth
import Foundation

public class BluetoothManager: NSObject {
    public static var shared: BluetoothManager {
        if _shared == nil {
            _shared = BluetoothManager()
        }
        return _shared! // swiftlint:disable:this force_unwrapping
    }
    
    public private(set) var peripherals = KikurageBluetoothPeripheralList(list: [])
    
    private let bluetoothClient: BluetoothClient

    private var writeWiFiScanCharacteristic: CBCharacteristic?
    private var notifyWiFiScanCharacteristic: CBCharacteristic?
    private var writeWiFiSettingChracteristic: CBCharacteristic?
    private var notifyWiFiCompletionChracteristic: CBCharacteristic?

    private static var _shared: BluetoothManager?
    
    // MARK: - Config

    override private init() {
        self.bluetoothClient = BluetoothClient(
            serviceId: BluetoothUUID.Service.m5stack.cbUUID,
            characteristicIds: BluetoothUUID.Characteristic.configCharactericticCBUUID()
        )
        super.init()
    }

    deinit {
        writeWiFiScanCharacteristic = nil
        notifyWiFiScanCharacteristic = nil
        notifyWiFiCompletionChracteristic = nil
    }

    public func release() {
        BluetoothManager._shared = nil
    }
    
    // MARK: - Scan / Connect
    
    public func startScan() {
        bluetoothClient.scanForPeripherals()
    }
    
    public func connect(index: Int) {
        let peripheral = peripherals.getElement(index: index).peripheral
        bluetoothClient.connectPeripheral(peripheral)
    }


    public func writeCommand(_ command: BluetoothCommand) {
        guard let sendData = command.valueJsonData, let characteristic = getCharacteristic(command) else {
            return
        }
    }

    private func getCharacteristic(_ command: BluetoothCommand) -> CBCharacteristic? {
        switch command {
        case .writeWiFiSetting:
            return writeWiFiSettingChracteristic
        case .writeStartWiFiScan, .writeStopWiFiScan:
            return writeWiFiScanCharacteristic
        }
    }
}

