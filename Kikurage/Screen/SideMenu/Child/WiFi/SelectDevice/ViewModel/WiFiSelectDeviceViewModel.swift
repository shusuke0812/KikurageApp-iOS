//
//  WiFiSelectDeviceViewModel.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2023/3/5.
//  Copyright © 2023 shusuke. All rights reserved.
//

import Foundation
import KikurageFeature
import UIKit.UITableView

protocol WiFiSelectDeviceViewModelDelegate: AnyObject {
    func viewModelDidAddPeripheral(_ wifiSelectDeviceViewModel: WiFiSelectDeviceViewModel)
    func viewModelDidSuccessConnectionToPeripheral(_ wifiSelectDeviceViewModel: WiFiSelectDeviceViewModel, peripheral: KikurageBluetoothPeripheral)
    func viewModelDidFailConnectionToPeripheral(_ wifiSelectDeviceViewModel: WiFiSelectDeviceViewModel, error: Error?)
}

class WiFiSelectDeviceViewModel: NSObject {
    private(set) var sections: [WiFiSelectDeviceSectionType] = [.device]

    private let bluetoothManager = KikurageBluetoothManager.shared
    private var bluetoothPeripherals = KikurageBluetoothPeripheralList(list: [])
    private var selectedIndexPath: IndexPath?
    private(set) var bluetoothCentralState: KikurageBluetoothCentralState?

    weak var delegate: WiFiSelectDeviceViewModelDelegate?

    override init() {
        super.init()
        bluetoothManager.peripheralDelegate = self
        bluetoothManager.centralDelegate = self
    }

    deinit {
        bluetoothManager.release()
    }

    private func add(peripheral: KikurageBluetoothPeripheral) {
        bluetoothPeripherals.add(peripheral: peripheral)
    }

    func connectToPeripheral(indexPath: IndexPath) {
        let peripheral = bluetoothPeripherals.getElement(indexPath: indexPath).peripheral
        bluetoothManager.connectPeripheral(peripheral)
        selectedIndexPath = indexPath
    }

    func scanForPeripherals() {
        bluetoothManager.scanForPeripherals()
    }
}

// MARK: - UITableViewDataSource

extension WiFiSelectDeviceViewModel: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        bluetoothPeripherals.listCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WiFiSelectDeviceTableViewCell", for: indexPath) as! WiFiSelectDeviceTableViewCell // swiftlint:disable:this force_cast
        cell.updateComponent(peripheral: bluetoothPeripherals.getElement(indexPath: indexPath))
        return cell
    }
}

// MARK: - KikurageBluetoothCentralManagerDelegate

extension WiFiSelectDeviceViewModel: KikurageBluetoothCentralManagerDelegate {
    func bluetoothManager(_ kikurageBluetoothManager: KikurageFeature.KikurageBluetoothManager, didUpdate state: KikurageFeature.KikurageBluetoothConnectionState) {
        switch state {
        case .connect:
            break
        case .disconnect(let error):
            delegate?.viewModelDidFailConnectionToPeripheral(self, error: error)
        case .fail(let error):
            delegate?.viewModelDidFailConnectionToPeripheral(self, error: error)
        case .standby:
            break
        }
    }

    func bluetoothManager(_ kikurageBluetoothManager: KikurageBluetoothManager, didUpdate state: KikurageBluetoothCentralState) {
        bluetoothCentralState = state
    }

    func bluetoothManager(_ kikurageBluetoothManager: KikurageBluetoothManager, didDiscover peripheral: KikurageBluetoothPeripheral) {
        if peripheral.validateConnection() {
            add(peripheral: peripheral)
            delegate?.viewModelDidAddPeripheral(self)
        }
    }
}

// MARK: - KikurageBluetoothPeripheralMangerDelegate

extension WiFiSelectDeviceViewModel: KikurageBluetoothPeripheralMangerDelegate {
    func bluetoothManager(_ kikurageBluetoothManager: KikurageFeature.KikurageBluetoothManager, didUpdateFor state: KikurageFeature.KikurageBluetoothPeripheralState) {
        switch state {
        case .didDiscoverCharacteristic:
            if let selectedIndexPath = selectedIndexPath {
                delegate?.viewModelDidSuccessConnectionToPeripheral(self, peripheral: bluetoothPeripherals.getElement(indexPath: selectedIndexPath))
            }
        case .standby:
            break
        }
    }

    func bluetoothManager(_ kikurageBluetoothManager: KikurageBluetoothManager, error: Error) {}

    func bluetoothManager(_ kikurageBluetoothManager: KikurageBluetoothManager, message: String) {}
}
