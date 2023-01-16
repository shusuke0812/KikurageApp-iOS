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
}

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
}
