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
}

extension KikurageBluetoothManager: CBCentralManagerDelegate {
    public func centralManagerDidUpdateState(_ central: CBCentralManager) {
    }
}
