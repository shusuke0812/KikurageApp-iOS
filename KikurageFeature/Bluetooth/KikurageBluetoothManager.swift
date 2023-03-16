//
//  KikurageBluetoothManager.swift
//  KikurageFeature
//
//  Created by Shusuke Ota on 2023/1/16.
//  Copyright © 2023 shusuke. All rights reserved.
//

import CoreBluetooth
import Foundation

public protocol KikurageBluetoothMangerDelegate: AnyObject {
    func bluetoothManager(_ kikurageBluetoothManager: KikurageBluetoothManager, error: Error)
    func bluetoothManager(_ kikurageBluetoothManager: KikurageBluetoothManager, message: String)
    func bluetoothManager(_ kikurageBluetoothManager: KikurageBluetoothManager, didDiscover peripheral: KikurageBluetoothPeripheral)
    func bluetoothManager(_ kikurageBluetoothManager: KikurageBluetoothManager, didUpdateFor connectionState: KikurageBluetoothConnectionState)
}

public class KikurageBluetoothManager: NSObject {
    private var centralManager: CBCentralManager!
    private var connectToPeripheral: CBPeripheral!

    private var writeCharacteristic: CBCharacteristic?
    private var notifyCharacteristic: CBCharacteristic?

    private let serviceUUID = CBUUID(string: KikurageBluetoothUUID.Service.debugM5Stack)
    private let characteristicUUID = CBUUID(string: KikurageBluetoothUUID.Characteristic.debugM5Stack9AxisX)

    public static let shared = KikurageBluetoothManager()
    public weak var delegate: KikurageBluetoothMangerDelegate?

    override private init() {
        super.init()
        initialize()
    }

    private func initialize() {
        centralManager = CBCentralManager(delegate: self, queue: nil, options: nil)
    }

    private func scanForPeripherals() {
        // TODO: setting original service ID
        centralManager.scanForPeripherals(withServices: nil, options: nil)
    }

    public func connectPeripheral(_ peripheral: CBPeripheral) {
        centralManager.connect(peripheral, options: nil)
        connectToPeripheral = peripheral
    }

    private func peripheralDiscoverServices() {
        connectToPeripheral.delegate = self
        connectToPeripheral.discoverServices([serviceUUID])
    }

    private func peripheralDiscoverCharacteristics(service: CBService) {
        connectToPeripheral.discoverCharacteristics([characteristicUUID], for: service)
    }
}

// MARK: - CBCentralManagerDelegate

extension KikurageBluetoothManager: CBCentralManagerDelegate {
    public func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOn:
            scanForPeripherals()
        case .poweredOff:
            break
        case .unknown:
            break
        case .resetting:
            break
        case .unsupported:
            break
        case .unauthorized:
            break
        @unknown default:
            fatalError()
        }
    }

    public func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String: Any], rssi RSSI: NSNumber) {
        delegate?.bluetoothManager(self, didDiscover: KikurageBluetoothPeripheral(advertisementData: advertisementData, rssi: RSSI, peripheral: peripheral))
    }

    public func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        delegate?.bluetoothManager(self, didUpdateFor: .connect)
        centralManager.stopScan()
        peripheralDiscoverServices()
    }

    public func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        delegate?.bluetoothManager(self, didUpdateFor: .fail(error))
    }

    public func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        delegate?.bluetoothManager(self, didUpdateFor: .disconnect(error))
    }
}

// MARK: - CBPeripheralDelegate

extension KikurageBluetoothManager: CBPeripheralDelegate {
    public func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if let error = error {
            delegate?.bluetoothManager(self, error: error)
            return
        }
        if let services = peripheral.services {
            services.forEach { service in
                peripheralDiscoverCharacteristics(service: service)
            }
        }
    }

    public func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if let error = error {
            delegate?.bluetoothManager(self, error: error)
            return
        }
        if let characteristics = service.characteristics {
            characteristics.forEach { characteristic in
                guard characteristic.uuid == characteristicUUID else {
                    return
                }
                connectToPeripheral.setNotifyValue(true, for: characteristic)
            }
        }
    }

    public func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if let error = error {
            delegate?.bluetoothManager(self, error: error)
            return
        }
        if let value = characteristic.value, let message = String(data: value, encoding: .utf8) {
            delegate?.bluetoothManager(self, message: message)
        }
    }

    public func peripheral(_ peripheral: CBPeripheral, didWriteValueFor descriptor: CBDescriptor, error: Error?) {}

    public func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {}
}
