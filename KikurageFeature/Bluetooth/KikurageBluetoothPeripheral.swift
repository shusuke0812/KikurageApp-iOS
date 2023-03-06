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
    public let uuid: UUID

    init(advertisementData: [String: Any], rssi: NSNumber, peripheral: CBPeripheral) {
        self.advertisementData = advertisementData
        self.rssi = rssi
        self.peripheral = peripheral
        self.uuid = UUID(uuid: peripheral.identifier.uuid)
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

public struct KikurageBluetoothPeripheralList {
    private var list: [KikurageBluetoothPeripheral]

    public init(list: [KikurageBluetoothPeripheral]) {
        self.list = list
    }

    public mutating func add(peripheral: KikurageBluetoothPeripheral) {
        list.append(peripheral)
    }

    public var listCount: Int {
        list.count
    }

    public func getElement(indexPath: IndexPath) -> KikurageBluetoothPeripheral {
        list[indexPath.row]
    }
}
