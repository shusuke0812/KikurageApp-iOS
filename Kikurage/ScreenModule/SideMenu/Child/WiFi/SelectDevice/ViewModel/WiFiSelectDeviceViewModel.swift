//
//  WiFiSelectDeviceViewModel.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2023/3/5.
//  Copyright © 2023 shusuke. All rights reserved.
//

import Foundation
import UIKit.UITableView
import KikurageFeature

protocol WiFiSelectDeviceViewModelDelegate: AnyObject {
    func viewModelDidAddPeripheral(_ wifiSelectDeviceViewModel: WiFiSelectDeviceViewModel)
}

class  WiFiSelectDeviceViewModel: NSObject {
    private let sections: [WiFiSectionType] = [.device]

    private let bluetoothManager = KikurageBluetoothManager()
    private var bluetoothPeripherals = KikurageBluetoothPeripheralList(list: [])

    weak var delegate: WiFiSelectDeviceViewModelDelegate?

    override init() {
        super.init()
        bluetoothManager.delegate = self
    }

    private func add(peripheral: KikurageBluetoothPeripheral) {
        bluetoothPeripherals.add(peripheral: peripheral)
    }

    func connectToPeripheral(indexPath: IndexPath) {
        let peripheral = bluetoothPeripherals.getElement(indexPath: indexPath).peripheral
        bluetoothManager.connectPeripheral(peripheral)
    }
}

// MARK: - UITableViewDataSource

extension WiFiSelectDeviceViewModel: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        sections[section].title
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        bluetoothPeripherals.listCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WiFiSelectDeviceTableViewCell", for: indexPath) as! WiFiSelectDeviceTableViewCell  // swiftlint:disable:this force_cast
        cell.updateComponent(peripheral: bluetoothPeripherals.getElement(indexPath: indexPath))
        return cell
    }
}

// MARK: - KikurageBluetoothMangerDelegate

extension WiFiSelectDeviceViewModel: KikurageBluetoothMangerDelegate {
    func bluetoothManager(_ kikurageBluetoothManager: KikurageBluetoothManager, error: Error) {
    }

    func bluetoothManager(_ kikurageBluetoothManager: KikurageBluetoothManager, message: String) {
    }

    func bluetoothManager(_ kikurageBluetoothManager: KikurageBluetoothManager, didDiscover peripheral: KikurageBluetoothPeripheral) {
        if peripheral.validateConnection() {
            add(peripheral: peripheral)
            delegate?.viewModelDidAddPeripheral(self)
        }
    }
}
