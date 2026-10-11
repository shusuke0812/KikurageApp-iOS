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
    private let sections: [WiFiSelectDeviceSectionType] = [.device]

    public var isBluetoothAvailable: Bool {
        return bluetoothManager.isBluetoothAvailable
    }

    public weak var delegate: WiFiSelectDeviceViewModelDelegate?
    public let state = WiFiSelectDeviceState()

    private let bluetoothManager = BluetoothManager.shared
    private var selectedIndexPath: IndexPath?

    override public init() {
        super.init()
        bluetoothManager.delegate = self
        state.sectionTitle = sections[0].title
    }

    deinit {
        bluetoothManager.release()
    }

    public func connectToPeripheral(indexPath: IndexPath) {
        state.isConnecting = true
        bluetoothManager.connect(index: indexPath.row)
        selectedIndexPath = indexPath
    }

    public func scanForPeripherals() {
        state.isScanning = true
        bluetoothManager.startScan()
    }

    public func disconnectPeripheral() {
        bluetoothManager.disconnect()
    }
}

// MARK: - Device List

extension WiFiSelectDeviceViewModel {
    private func makeDevices() -> [WiFiDeviceInfo] {
        (0..<bluetoothManager.peripherals.listCount).map { index in
            let peripheral = bluetoothManager.peripherals.getElement(index: index)
            let signal = BluetoothSignal.getSignal(rssi: peripheral.rssiInt)

            return WiFiDeviceInfo(
                id: index,
                signalImage: signal.image,
                rssiString: peripheral.rssiString,
                deviceName: peripheral.deviceName,
                serviceCountString: peripheral.serviceCountString
            )
        }
    }
}

// MARK: - BluetoothManagerConnectionDelegate

extension WiFiSelectDeviceViewModel: BluetoothManagerDelegate {
    public func bluetoothManagerDidReceivedValue(_ bluetoothManager: KDBluetoothManager.BluetoothManager, message: String) {}

    public func bluetoothManager(_ bluetoothManager: BluetoothManager, isConnected: Bool) {
        if !isConnected {
            state.isConnecting = false
            delegate?.viewModelDidFailConnectionToPeripheral(self)
        }
    }

    public func bluetoothManagerDidDiscovered(_ bluetoothManager: BluetoothManager) {
        state.isScanning = false
        state.devices = makeDevices()
        delegate?.viewModelDidAddPeripheral(self)
    }

    public func bluetoothManagerDidConnected(_ bluetoothManager: BluetoothManager) {
        if let selectedIndexPath = selectedIndexPath {
            bluetoothManager.setupSelectedPeripheral(index: selectedIndexPath.row)
            state.isConnecting = false
            delegate?.viewModelDidSuccessConnectionToPeripheral(self)
        }
    }
}
