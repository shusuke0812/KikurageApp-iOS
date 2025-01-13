//
//  BluetoothPeripheral.swift
//  KikurageFeature
//
//  Created by Shusuke Ota on 2023/03/06.
//  Copyright © 2023 shusuke. All rights reserved.
//

import CoreBluetooth
import Foundation

public struct BluetoothPeripheral {
    public let advertisementData: [String: Any]
    public let rssi: NSNumber
    public let peripheral: CBPeripheral
    public let uuid: UUID

    public init(advertisementData: [String: Any], rssi: NSNumber, peripheral: CBPeripheral) {
        self.advertisementData = advertisementData
        self.rssi = rssi
        self.peripheral = peripheral
        uuid = UUID(uuid: peripheral.identifier.uuid)
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
        deviceName == BluetoothUUID.LocalName.debugM5Stack
    }
}

public struct BluetoothPeripheralList {
    private var list: [BluetoothPeripheral]

    public init(list: [BluetoothPeripheral]) {
        self.list = list
    }

    public mutating func add(peripheral: BluetoothPeripheral) {
        list.append(peripheral)
    }

    public var listCount: Int {
        list.count
    }

    public func getElement(index: Int) -> BluetoothPeripheral {
        list[index]
    }
}
