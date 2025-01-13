//
//  BluetoothClient.swift
//  KikurageDomain
//
//  Created by Shusuke Ota on 2025/1/12.
//

import CoreBluetooth
import Foundation

public protocol BluetoothCentralManagerDelegate: AnyObject {
    func bluetoothManager(_ bluetoothClient: BluetoothClient, didUpdate state: CBManagerState)
    func bluetoothManager(_ bluetoothClient: BluetoothClient, didDiscover peripheral: CBPeripheral, advertisementData: [String: Any], rssi RSSI: NSNumber)
    func bluetoothManager(_ bluetoothClient: BluetoothClient, didUpdate connectionState: BluetoothConnectionState)
}

public protocol BluetoothPeripheralMangerDelegate: AnyObject {
    func bluetoothManager(_ bluetoothClient: BluetoothClient, error: Error)
    func bluetoothManager(_ bluetoothClient: BluetoothClient, message: String)
    func bluetoothManager(_ bluetoothClient: BluetoothClient, didUpdateFor state: BluetoothPeripheralState)
}

public class BluetoothClient: NSObject {
    private var centralManager: CBCentralManager!
    private var connectToPeripheral: CBPeripheral!

    private let connectServiceID: CBUUID
    private let connectCharacteristicIDs: [CBUUID]

    public weak var peripheralDelegate: BluetoothPeripheralMangerDelegate?
    public weak var centralDelegate: BluetoothCentralManagerDelegate?

    public init(serviceID: CBUUID, characteristicIDs: [CBUUID]) {
        connectServiceID = serviceID
        connectCharacteristicIDs = characteristicIDs
        super.init()

        setupManager()
    }

    deinit {
        peripheralDelegate = nil
        centralDelegate = nil
    }

    private func setupManager() {
        centralManager = CBCentralManager(delegate: self, queue: nil, options: nil)
    }

    public func scanForPeripherals() {
        // TODO: setting original service ID
        centralManager.scanForPeripherals(withServices: nil, options: nil)
    }

    public func connectPeripheral(_ peripheral: CBPeripheral) {
        centralManager.connect(peripheral, options: nil)
        connectToPeripheral = peripheral
    }

    public func disconnectPeripheral() {
        guard let peripheral = connectToPeripheral else {
            return
        }
        centralManager.cancelPeripheralConnection(peripheral)
        connectToPeripheral = nil
    }

    public func writeWithResponse(_ characteristic: CBCharacteristic, data: Data) {
        connectToPeripheral.writeValue(data, for: characteristic, type: .withResponse)
    }

    public func writeWOResponse(_ characteristic: CBCharacteristic, data: Data) {
        connectToPeripheral.writeValue(data, for: characteristic, type: .withoutResponse)
    }

    public func setupNotify(for characteristic: CBCharacteristic) {
        connectToPeripheral.setNotifyValue(true, for: characteristic)
    }

    private func peripheralDiscoverServices() {
        connectToPeripheral.delegate = self
        connectToPeripheral.discoverServices([connectServiceID])
    }

    private func peripheralDiscoverCharacteristics(service: CBService) {
        connectToPeripheral.discoverCharacteristics(connectCharacteristicIDs, for: service)
    }
}

// MARK: - CBCentralManagerDelegate

extension BluetoothClient: CBCentralManagerDelegate {
    public func centralManagerDidUpdateState(_ central: CBCentralManager) {
        centralDelegate?.bluetoothManager(self, didUpdate: central.state)
    }

    public func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String: Any], rssi RSSI: NSNumber) {
        centralDelegate?.bluetoothManager(self, didDiscover: peripheral, advertisementData: advertisementData, rssi: RSSI)
    }

    public func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        centralDelegate?.bluetoothManager(self, didUpdate: .connect)
        centralManager.stopScan()
        peripheralDiscoverServices()
    }

    public func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        centralDelegate?.bluetoothManager(self, didUpdate: .fail(error))
    }

    public func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        centralDelegate?.bluetoothManager(self, didUpdate: .disconnect(error))
    }
}

// MARK: - CBPeripheralDelegate

extension BluetoothClient: CBPeripheralDelegate {
    public func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if let error = error {
            peripheralDelegate?.bluetoothManager(self, error: error)
            return
        }
        if let services = peripheral.services {
            for service in services {
                peripheralDiscoverCharacteristics(service: service)
            }
        }
    }

    public func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if let error = error {
            peripheralDelegate?.bluetoothManager(self, error: error)
            return
        }
        peripheralDelegate?.bluetoothManager(self, didUpdateFor: .didDiscoverCharacteristic(service.characteristics))
    }

    public func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if let error = error {
            peripheralDelegate?.bluetoothManager(self, error: error)
            return
        }
        if let value = characteristic.value, let message = String(data: value, encoding: .utf8) {
            peripheralDelegate?.bluetoothManager(self, message: message)
        }
    }

    public func peripheral(_ peripheral: CBPeripheral, didWriteValueFor descriptor: CBDescriptor, error: Error?) {}

    public func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {}
}
