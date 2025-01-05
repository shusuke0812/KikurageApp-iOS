//
//  WiFiSelectDeviceViewModel.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2023/3/5.
//  Copyright © 2023 shusuke. All rights reserved.
//

import KSFeatures
import Foundation
import UIKit.UITableView

public protocol WiFiSelectDeviceViewModelDelegate: AnyObject {
    func viewModelDidAddPeripheral(_ wifiSelectDeviceViewModel: WiFiSelectDeviceViewModel)
    func viewModelDidSuccessConnectionToPeripheral(_ wifiSelectDeviceViewModel: WiFiSelectDeviceViewModel, peripheral: KikurageBluetoothPeripheral)
    func viewModelDidFailConnectionToPeripheral(_ wifiSelectDeviceViewModel: WiFiSelectDeviceViewModel, error: Error?)
}

public class WiFiSelectDeviceViewModel: NSObject {
    private(set) var sections: [WiFiSelectDeviceSectionType] = [.device]

    private let bluetoothManager = KikurageBluetoothManager.shared
    private var bluetoothPeripherals = KikurageBluetoothPeripheralList(list: [])
    private var selectedIndexPath: IndexPath?
    private(set) var bluetoothCentralState: KikurageBluetoothCentralState?

    public weak var delegate: WiFiSelectDeviceViewModelDelegate?

    public override init() {
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

    public func connectToPeripheral(indexPath: IndexPath) {
        let peripheral = bluetoothPeripherals.getElement(indexPath: indexPath).peripheral
        bluetoothManager.connectPeripheral(peripheral)
        selectedIndexPath = indexPath
    }

    public func scanForPeripherals() {
        bluetoothManager.scanForPeripherals()
    }
}

// MARK: - UITableViewDataSource

extension WiFiSelectDeviceViewModel: UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        bluetoothPeripherals.listCount
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WiFiSelectDeviceTableViewCell", for: indexPath) as! WiFiSelectDeviceTableViewCell // swiftlint:disable:this force_cast
        cell.updateComponent(peripheral: bluetoothPeripherals.getElement(indexPath: indexPath))
        return cell
    }
}

// MARK: - KikurageBluetoothCentralManagerDelegate

extension WiFiSelectDeviceViewModel: KikurageBluetoothCentralManagerDelegate {
    public func bluetoothManager(_ kikurageBluetoothManager: KikurageBluetoothManager, didUpdate state: KikurageBluetoothConnectionState) {
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

    public func bluetoothManager(_ kikurageBluetoothManager: KikurageBluetoothManager, didUpdate state: KikurageBluetoothCentralState) {
        bluetoothCentralState = state
    }

    public func bluetoothManager(_ kikurageBluetoothManager: KikurageBluetoothManager, didDiscover peripheral: KikurageBluetoothPeripheral) {
        if peripheral.validateConnection() {
            add(peripheral: peripheral)
            delegate?.viewModelDidAddPeripheral(self)
        }
    }
}

// MARK: - KikurageBluetoothPeripheralMangerDelegate

extension WiFiSelectDeviceViewModel: KikurageBluetoothPeripheralMangerDelegate {
    public func bluetoothManager(_ kikurageBluetoothManager: KikurageBluetoothManager, didUpdateFor state: KikurageBluetoothPeripheralState) {
        switch state {
        case .didDiscoverCharacteristic:
            if let selectedIndexPath = selectedIndexPath {
                delegate?.viewModelDidSuccessConnectionToPeripheral(self, peripheral: bluetoothPeripherals.getElement(indexPath: selectedIndexPath))
            }
        case .standby:
            break
        }
    }

    public func bluetoothManager(_ kikurageBluetoothManager: KikurageBluetoothManager, error: Error) {}

    public func bluetoothManager(_ kikurageBluetoothManager: KikurageBluetoothManager, message: String) {}
}
