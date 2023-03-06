//
//  WiFiSelectDeviceViewController.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2023/3/5.
//  Copyright © 2023 shusuke. All rights reserved.
//

import UIKit
import KikurageFeature

class WiFiSelectDeviceViewController: UIViewController {
    private let baseView = WiFiSelectDeviceBaseView()
    private let viewModel = WiFiSelectDeviceViewModel()

    private let bluetoothManager = KikurageBluetoothManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupProtocols()
        setupNavigation()

        bluetoothManager.delegate = self
    }

    override func loadView() {
        view = baseView
    }

    // MARK: - Action

    @objc private func close(_ sender: UIBarButtonItem) {
        presentingViewController?.dismiss(animated: true)
    }

    private func setupProtocols() {
        baseView.setupTableViewProtocols(delegate: self, dataSource: viewModel)
    }

    private func setupNavigation() {
        let closeButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(close(_:)))
        navigationItem.rightBarButtonItems = [closeButtonItem]
        navigationItem.title = R.string.localizable.side_menu_wifi_select_device_title()
    }
}

// MARK: - UITableViewDelegate

extension WiFiSelectDeviceViewController: UITableViewDelegate {
}

// MARK: - KikurageBluetoothMangerDelegate

extension WiFiSelectDeviceViewController: KikurageBluetoothMangerDelegate {
    func bluetoothManager(_ kikurageBluetoothManager: KikurageBluetoothManager, error: Error) {
    }

    func bluetoothManager(_ kikurageBluetoothManager: KikurageBluetoothManager, message: String) {
    }

    func bluetoothManager(_ kikurageBluetoothManager: KikurageBluetoothManager, didDiscover peripheral: KikurageBluetoothPeripheral) {
        viewModel.add(peripheral: peripheral)
        DispatchQueue.main.async {
            self.baseView.tableView.reloadData()
        }
    }
}
