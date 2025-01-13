//
//  KikurageBluetoothManager.swift
//  KikurageFeature
//
//  Created by Shusuke Ota on 2023/1/16.
//  Copyright © 2023 shusuke. All rights reserved.
//

import KALogger
import KDBluetooth
import CoreBluetooth
import Foundation

public protocol BluetoothManagerDelegate {
    func bluetoothManager(_ bluetoothManager: BluetoothManager, isConnected: Bool)
    func bluetoothManagerDidDiscovered(_ bluetoothManager: BluetoothManager)
    func bluetoothManagerDidConnected(_ bluetoothManager: BluetoothManager)
    func bluetoothManagerDidReceivedValue(_ bluetoothManager: BluetoothManager, message: String)
}

public class BluetoothManager: NSObject {
    public static var shared: BluetoothManager {
        if _shared == nil {
            _shared = BluetoothManager()
        }
        return _shared! // swiftlint:disable:this force_unwrapping
    }
    
    public private(set) var peripherals = BluetoothPeripheralList(list: [])
    public private(set) var selectedPeripheral: BluetoothPeripheral?
    public var isBluetoothAvailable: Bool {
        centralState?.value == .poweredOn
    }
    
    public var delegate: BluetoothManagerDelegate?
    
    private let bluetoothClient: BluetoothClient

    private var writeWiFiScanCharacteristic: CBCharacteristic?
    private var notifyWiFiScanCharacteristic: CBCharacteristic?
    private var writeWiFiSettingChracteristic: CBCharacteristic?
    private var notifyWiFiCompletionChracteristic: CBCharacteristic?
    
    private var centralState: BluetoothCentralState?

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
    
    private func setupDelegate() {
        bluetoothClient.centralDelegate = self
        bluetoothClient.peripheralDelegate = self
    }

    public func release() {
        BluetoothManager._shared = nil
    }
    
    public func setupSelectedPeripheral(index: Int) {
        selectedPeripheral = peripherals.getElement(index: index)
    }
    
    // MARK: - Scan / Connect
    
    public func startScan() {
        bluetoothClient.scanForPeripherals()
    }
    
    public func connect(index: Int) {
        let peripheral = peripherals.getElement(index: index).peripheral
        bluetoothClient.connectPeripheral(peripheral)
    }

    // MARK: - GATT

    public func writeCommand(_ command: BluetoothCommand) {
        guard let sendData = command.valueJsonData, let characteristic = getCharacteristic(command) else {
            return
        }
        bluetoothClient.writeWithResponse(characteristic, data: sendData)
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

// MARK: - BluetoothCentralManagerDelegate

extension BluetoothManager: BluetoothCentralManagerDelegate {
    public func bluetoothManager(_ bluetoothClient: BluetoothClient, didUpdate state: CBManagerState) {
        let cs = BluetoothCentralState(value: state)
        centralState = cs
        
        KLogManager.debug("central state: \(state)")
    }
    public func bluetoothManager(_ bluetoothClient: BluetoothClient, didDiscover peripheral: CBPeripheral, advertisementData: [String: Any], rssi RSSI: NSNumber) {
        let peripheral = BluetoothPeripheral(advertisementData: advertisementData, rssi: RSSI, peripheral: peripheral)
        if peripheral.validateConnection() {
            peripherals.add(peripheral: peripheral)
            delegate?.bluetoothManagerDidDiscovered(self)
        }
    }
    public func bluetoothManager(_ bluetoothClient: BluetoothClient, didUpdate connectionState: BluetoothConnectionState) {
        switch connectionState {
        case .connect:
            delegate?.bluetoothManager(self, isConnected: true)
        case .disconnect(let error), .fail(let error):
            if let error = error {
                KLogManager.debug("\(error)")
            }
            delegate?.bluetoothManager(self, isConnected: false)
        case .standby:
            delegate?.bluetoothManager(self, isConnected: false)
        }
        
    }
}

// MARK: - BluetoothPeripheralMangerDelegate

extension BluetoothManager: BluetoothPeripheralMangerDelegate {
    public func bluetoothManager(_ bluetoothClient: BluetoothClient, error: Error) {
        
    }
    public func bluetoothManager(_ bluetoothClient: BluetoothClient, message: String) {
        delegate?.bluetoothManagerDidReceivedValue(self, message: message)
    }
    public func bluetoothManager(_ bluetoothClient: BluetoothClient, didUpdateFor state: BluetoothPeripheralState) {
        switch state {
        case .didDiscoverCharacteristic(let characteristics):
            guard let _characteristics = characteristics else {
                return
            }
            for characteristic in _characteristics {
                let uuidString = characteristic.uuid.uuidString.lowercased()
                if uuidString == BluetoothUUID.Characteristic.readWiFi.uuidString {
                    notifyWiFiScanCharacteristic = characteristic
                    bluetoothClient.setupNotify(for: characteristic)
                }
                if uuidString == BluetoothUUID.Characteristic.writeStopWiFiScan.uuidString {
                    writeWiFiScanCharacteristic = characteristic
                }
                if uuidString == BluetoothUUID.Characteristic.writeWiFiSetting.uuidString {
                    writeWiFiSettingChracteristic = characteristic
                }
                if uuidString == BluetoothUUID.Characteristic.readCompletion.uuidString {
                    notifyWiFiCompletionChracteristic = characteristic
                    bluetoothClient.setupNotify(for: characteristic)
                }
            }
            delegate?.bluetoothManagerDidConnected(self)
        case .standby:
            KLogManager.debug("characteristic state: standby")
            break
        }
    }
}
