//
//  KikurageBluetoothManager.swift
//  KikurageFeature
//
//  Created by Shusuke Ota on 2023/1/16.
//  Copyright © 2023 shusuke. All rights reserved.
//

import Foundation
import CoreBluetooth

public protocol KikurageBluetoothMangerDelegate: AnyObject {
    func bluetoothManager(_ kikurageBluetoothManager: KikurageBluetoothManager, error: Error)
    func bluetoothManager(_ kikurageBluetoothManager: KikurageBluetoothManager, message: String)
    func bluetoothManager(_ kikurageBluetoothManager: KikurageBluetoothManager, didDiscover peripheral: KikurageBluetoothPeripheral)
}

public class KikurageBluetoothManager: NSObject {
    public weak var delegate: KikurageBluetoothMangerDelegate?

    private var centralManager: CBCentralManager!
    private var connectToPeripheral: CBPeripheral!

    private var writeCharacteristic: CBCharacteristic?
    private var notifyCharacteristic: CBCharacteristic?

    override public init() {
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
        connectToPeripheral = peripheral
        centralManager.stopScan()
        centralManager.connect(connectToPeripheral, options: nil)
    }

    private func peripheralDiscoverServices() {
        connectToPeripheral.delegate = self
        connectToPeripheral.discoverServices(nil) // TODO: setting original service ID
    }

    private func peripheralDiscoverCharacteristics(service: CBService) {
        connectToPeripheral.discoverCharacteristics(nil, for: service) // TODO: setting original characteristic ID
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
        peripheralDiscoverServices()
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
                switch characteristic.properties {
                case .write:
                    writeCharacteristic = characteristic
                case .notify:
                    notifyCharacteristic = characteristic
                default:
                    break
                }
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

    public func peripheral(_ peripheral: CBPeripheral, didWriteValueFor descriptor: CBDescriptor, error: Error?) {
    }

    public func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
    }
}
