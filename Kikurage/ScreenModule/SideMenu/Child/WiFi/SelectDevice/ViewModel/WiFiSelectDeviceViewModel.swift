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

class  WiFiSelectDeviceViewModel: NSObject {
    private let sections: [WiFiSectionType] = [.device]
    private var bluetoothPeripherals = KikurageBluetoothPeripheralList(list: [])

    override init() {
    }

    func add(peripheral: KikurageBluetoothPeripheral) {
        bluetoothPeripherals.add(peripheral: peripheral)
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
