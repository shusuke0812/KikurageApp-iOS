//
//  WiFiSelectDeviceViewController.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2023/3/5.
//  Copyright © 2023 shusuke. All rights reserved.
//

import KAAnalytics
import KSWiFiService
import UIKit

class WiFiSelectDeviceViewController: UIViewController, UIViewControllerNavigatable, WiFiAccessable {
    private let viewModel = WiFiSelectDeviceViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        viewModel.delegate = self

        let baseView = WiFiSelectDeviceBaseView(state: viewModel.state, delegate: self)
        let _ = addBaseView(baseView: baseView)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.disconnectPeripheral()

        if viewModel.isBluetoothAvailable {
            viewModel.scanForPeripherals()
        }
        FirebaseAnalyticsManager.sendScreenViewEvent(.wifi)
    }

    // MARK: - Action

    @objc private func close(_ sender: UIBarButtonItem) {
        presentingViewController?.dismiss(animated: true)
        // TODO: WiFi disconnected
    }

    private func setupNavigation() {
        let closeButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(close(_:)))
        navigationItem.rightBarButtonItems = [closeButtonItem]
        navigationItem.title = R.string.localizable.side_menu_wifi_select_device_title()
    }
}

// MARK: - WiFiSelectDeviceBaseView Delegate

extension WiFiSelectDeviceViewController: WiFiSelectDeviceBaseViewDelegate {
    func wifiSelectDeviceBaseViewDidSelectDevice(index: Int) {
        viewModel.connectToPeripheral(indexPath: IndexPath(row: index, section: 0))
    }
}

// MARK: - WiFiSelectDeviceViewModelDelegate

extension WiFiSelectDeviceViewController: WiFiSelectDeviceViewModelDelegate {
    func viewModelDidAddPeripheral(_ wifiSelectDeviceViewModel: WiFiSelectDeviceViewModel) {}

    func viewModelDidSuccessConnectionToPeripheral(_ wifiSelectDeviceViewModel: WiFiSelectDeviceViewModel) {
        DispatchQueue.main.async { [weak self] in
            self?.pushToWiFiList()
        }
    }

    func viewModelDidFailConnectionToPeripheral(_ wifiSelectDeviceViewModel: WiFiSelectDeviceViewModel) {}
}
