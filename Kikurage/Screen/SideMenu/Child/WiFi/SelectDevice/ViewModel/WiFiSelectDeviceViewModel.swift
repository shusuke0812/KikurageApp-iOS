//
//  WiFiSelectDeviceViewModel.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2023/3/5.
//  Copyright © 2023 shusuke. All rights reserved.
//

import Foundation
import KDBluetoothManager

protocol WiFiSelectDeviceViewModelDelegate: AnyObject {
    func viewModelDidAddPeripheral(_ wifiSelectDeviceViewModel: WiFiSelectDeviceViewModel)
    func viewModelDidSuccessConnectionToPeripheral(_ wifiSelectDeviceViewModel: WiFiSelectDeviceViewModel)
    func viewModelDidFailConnectionToPeripheral(_ wifiSelectDeviceViewModel: WiFiSelectDeviceViewModel)
}

class WiFiSelectDeviceViewModel: NSObject {
    private let sections: [WiFiSelectDeviceSectionType] = [.device]

    var isBluetoothAvailable: Bool {
        return bluetoothManager.isBluetoothAvailable
    }

    weak var delegate: WiFiSelectDeviceViewModelDelegate?
    let state = WiFiSelectDeviceState()

    private let bluetoothManager = BluetoothManager.shared
    private var selectedIndexPath: IndexPath?

    override init() {
        super.init()
        state.sectionTitle = sections[0].title
    }

    deinit {
        bluetoothManager.release()
    }

    func bluetoothDelegate() {
        bluetoothManager.delegate = self
    }

    func connectToPeripheral(indexPath: IndexPath) {
        state.isConnecting = true
        bluetoothManager.connect(index: indexPath.row)
        selectedIndexPath = indexPath
    }

    func scanForPeripherals() {
        state.isScanning = true
        bluetoothManager.startScan()
    }

    func disconnectPeripheral() {
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
    func bluetoothManagerDidReceivedValue(_ bluetoothManager: KDBluetoothManager.BluetoothManager, message: String) {}

    func bluetoothManager(_ bluetoothManager: BluetoothManager, isConnected: Bool) {
        if !isConnected {
            state.isConnecting = false
            delegate?.viewModelDidFailConnectionToPeripheral(self)
        }
    }

    func bluetoothManagerDidDiscovered(_ bluetoothManager: BluetoothManager) {
        state.isScanning = false
        state.devices = makeDevices()
        delegate?.viewModelDidAddPeripheral(self)
    }

    func bluetoothManagerDidConnected(_ bluetoothManager: BluetoothManager) {
        if let selectedIndexPath = selectedIndexPath {
            bluetoothManager.setupSelectedPeripheral(index: selectedIndexPath.row)
            state.isConnecting = false
            delegate?.viewModelDidSuccessConnectionToPeripheral(self)
        }
    }
}
