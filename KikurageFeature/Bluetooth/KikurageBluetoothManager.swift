//
//  KikurageBluetoothManager.swift
//  KikurageFeature
//
//  Created by Shusuke Ota on 2023/1/16.
//  Copyright © 2023 shusuke. All rights reserved.
//

import Foundation
import CoreBluetooth

public class KikurageBluetoothManager: NSObject {
    private var centralManager: CBCentralManager!
    private let connectToLocalName = "M5Stack" // TODO: change name
    private var connectToPeripheral: CBPeripheral!

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
    
    private func connectPeripheral() {
        centralManager.stopScan()
        centralManager.connect(connectToPeripheral, options: nil)
    }
}

// MARK: - CBCentralManagerDelegate

extension KikurageBluetoothManager: CBCentralManagerDelegate {
    public func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOn:
            print("DEBUG")
        case .poweredOff:
            print("DEBUG")
        case .unknown:
            print("DEBUG")
        case .resetting:
            print("DEBUG")
        case .unsupported:
            print("DEBUG")
        case .unauthorized:
            print("DEBUG")
        @unknown default:
            fatalError()
        }
    }

    public func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String: Any], rssi RSSI: NSNumber) {
        let uuid = UUID(uuid: peripheral.identifier.uuid)
        if let localName = advertisementData[CBAdvertisementDataLocalNameKey] as? String {
            if localName == connectToLocalName {
                print("DEBUG: uuid=\(uuid)")
                connectToPeripheral = peripheral
                connectPeripheral()
            }
        }
    }
}
