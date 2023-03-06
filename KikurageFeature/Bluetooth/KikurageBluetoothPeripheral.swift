//
//  KikurageBluetoothPeripheral.swift
//  KikurageFeature
//
//  Created by Shusuke Ota on 2023/03/06.
//  Copyright © 2023 shusuke. All rights reserved.
//

import Foundation
import CoreBluetooth

public struct KikurageBluetoothPeripheral {
    public let advertisementData: [String: Any]
    public let rssi: NSNumber
    public let peripheral: CBPeripheral
    
    init(advertisementData: [String: Any], rssi: NSNumber, peripheral: CBPeripheral) {
        self.advertisementData = advertisementData
        self.rssi = rssi
        self.peripheral = peripheral
    }
    
    public var deviceName: String {
        if let localName = advertisementData[CBAdvertisementDataLocalNameKey] as? String {
            return localName
        } else {
            return "Unnamed"
        }
    }
    
    public var rssiInt: Int {
        rssi.intValue
    }
    
    public var rssiString: String {
        "\(rssiInt)"
    }
    
    public var serviceCountString: String {
        if let services = peripheral.services {
            return "\(services.count) services"
        } else {
            return "No services"
        }
    }
    
    public func validateConnection() -> Bool {
        deviceName == KikurageBluetoothUUID.LocalName.debugM5Stack
    }
}
