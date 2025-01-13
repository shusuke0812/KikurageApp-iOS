//
//  WiFiSelectDeviceViewModel.swift
//  KikurageService
//
//  Created by Shusuke Ota on 2023/3/5.
//  Copyright © 2023 shusuke. All rights reserved.
//

import Foundation
import KDBluetoothManager

public protocol WiFiSelectDeviceViewModelDelegate: AnyObject {
    func viewModelDidAddPeripheral(_ wifiSelectDeviceViewModel: WiFiSelectDeviceViewModel)
    func viewModelDidSuccessConnectionToPeripheral(_ wifiSelectDeviceViewModel: WiFiSelectDeviceViewModel)
    func viewModelDidFailConnectionToPeripheral(_ wifiSelectDeviceViewModel: WiFiSelectDeviceViewModel)
}

public class WiFiSelectDeviceViewModel: NSObject {
    public private(set) var sections: [WiFiSelectDeviceSectionType] = [.device]
    public var isBluetoothAvailable: Bool {
        return bluetoothManager.isBluetoothAvailable
    }

    public weak var delegate: WiFiSelectDeviceViewModelDelegate?

    private let bluetoothManager = BluetoothManager.shared
    private var selectedIndexPath: IndexPath?

    override public init() {
        super.init()
        bluetoothManager.delegate = self
    }

    deinit {
        bluetoothManager.release()
    }

    public func sectionRows() -> Int {
        bluetoothManager.peripherals.listCount
    }

    public func connectToPeripheral(indexPath: IndexPath) {
        bluetoothManager.connect(index: indexPath.row)
        selectedIndexPath = indexPath
    }

    public func scanForPeripherals() {
        bluetoothManager.startScan()
    }

    public func getPeripheralInfo(index: Int) -> (signal: BluetoothSignal, peripheral: BluetoothPeripheral) {
        let peripheral = bluetoothManager.peripherals.getElement(index: index)
        let signal = BluetoothSignal.getSignal(rssi: peripheral.rssiInt)

        return (signal, peripheral)
    }
}

// MARK: - BluetoothManagerConnectionDelegate

extension WiFiSelectDeviceViewModel: BluetoothManagerDelegate {
    public func bluetoothManagerDidReceivedValue(_ bluetoothManager: KDBluetoothManager.BluetoothManager, message: String) {}

    public func bluetoothManager(_ bluetoothManager: BluetoothManager, isConnected: Bool) {
        if !isConnected {
            delegate?.viewModelDidFailConnectionToPeripheral(self)
        }
    }

    public func bluetoothManagerDidDiscovered(_ bluetoothManager: BluetoothManager) {
        delegate?.viewModelDidAddPeripheral(self)
    }

    public func bluetoothManagerDidConnected(_ bluetoothManager: BluetoothManager) {
        if let selectedIndexPath = selectedIndexPath {
            bluetoothManager.setupSelectedPeripheral(index: selectedIndexPath.row)
            delegate?.viewModelDidSuccessConnectionToPeripheral(self)
        }
    }
}
