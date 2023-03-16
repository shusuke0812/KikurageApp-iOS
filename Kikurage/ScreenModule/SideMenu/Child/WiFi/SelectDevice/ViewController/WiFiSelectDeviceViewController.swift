//
//  WiFiSelectDeviceViewController.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2023/3/5.
//  Copyright © 2023 shusuke. All rights reserved.
//

import KikurageFeature
import UIKit

class WiFiSelectDeviceViewController: UIViewController, WiFiAccessable {
    private let baseView = WiFiSelectDeviceBaseView()
    private let viewModel = WiFiSelectDeviceViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupProtocols()
        setupNavigation()

        viewModel.delegate = self
    }

    override func loadView() {
        view = baseView
    }

    // MARK: - Action

    @objc private func close(_ sender: UIBarButtonItem) {
        presentingViewController?.dismiss(animated: true)
        // TODO: WiFi disconnected
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.connectToPeripheral(indexPath: indexPath)
    }
}

// MARK: - WiFiSelectDeviceViewModelDelegate

extension WiFiSelectDeviceViewController: WiFiSelectDeviceViewModelDelegate {
    func viewModelDidAddPeripheral(_ wifiSelectDeviceViewModel: WiFiSelectDeviceViewModel) {
        DispatchQueue.main.async {
            self.baseView.tableView.reloadData()
        }
    }

    func viewModelDisSuccessConnectionToPeripheral(_ wifiSelectDeviceViewModel: WiFiSelectDeviceViewModel, peripheral: KikurageBluetoothPeripheral) {
        DispatchQueue.main.async {
            self.pushToWiFiList(bluetoothPeriperal: peripheral)
        }
    }
}
