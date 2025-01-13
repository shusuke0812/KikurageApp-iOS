//
//  WiFiSelectDeviceViewController.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2023/3/5.
//  Copyright © 2023 shusuke. All rights reserved.
//

import KAAnalytics
import KSWiFiService
import KUIKit
import PKHUD
import UIKit

class WiFiSelectDeviceViewController: UIViewController, WiFiAccessable {
    private let baseView = WiFiSelectDeviceBaseView()
    private let viewModel = WiFiSelectDeviceViewModel()

    override func loadView() {
        view = baseView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupProtocols()
        setupNavigation()

        viewModel.delegate = self
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.disconnectPeripheral()

        if viewModel.isBluetoothAvailable {
            baseView.tableViewHeaderView.startIndicatorAnimating()
            viewModel.scanForPeripherals()
        }
        FirebaseAnalyticsManager.sendScreenViewEvent(.wifi)
    }

    // MARK: - Action

    @objc private func close(_ sender: UIBarButtonItem) {
        presentingViewController?.dismiss(animated: true)
        // TODO: WiFi disconnected
    }

    private func setupProtocols() {
        baseView.setupTableViewProtocols(delegate: self, dataSource: self)
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
        HUD.show(.progress)
        viewModel.connectToPeripheral(indexPath: indexPath)
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        baseView.setupTableViewHeaderView(KUITableHeaderView.create(tableView: tableView))
        baseView.tableViewHeaderView.setupTitleLabel(viewModel.sections[section].title)
        return baseView.tableViewHeaderView
    }
}

// MARK: - UITableViewDataSource

extension WiFiSelectDeviceViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.sectionRows()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WiFiSelectDeviceTableViewCell", for: indexPath) as! WiFiSelectDeviceTableViewCell // swiftlint:disable:this force_cast
        cell.updateComponent(
            signalImage: viewModel.getPeripheralInfo(index: indexPath.row).signal.image,
            rssiString: viewModel.getPeripheralInfo(index: indexPath.row).peripheral.rssiString,
            deviceName: viewModel.getPeripheralInfo(index: indexPath.row).peripheral.deviceName,
            serviceCountString: viewModel.getPeripheralInfo(index: indexPath.row).peripheral.serviceCountString
        )
        return cell
    }
}

// MARK: - WiFiSelectDeviceViewModelDelegate

extension WiFiSelectDeviceViewController: WiFiSelectDeviceViewModelDelegate {
    func viewModelDidAddPeripheral(_ wifiSelectDeviceViewModel: WiFiSelectDeviceViewModel) {
        DispatchQueue.main.async {
            self.baseView.tableViewHeaderView.stopIndicatorAnimating()
            self.baseView.tableView.reloadData()
        }
    }

    func viewModelDidSuccessConnectionToPeripheral(_ wifiSelectDeviceViewModel: WiFiSelectDeviceViewModel) {
        DispatchQueue.main.async {
            HUD.hide()
            self.pushToWiFiList()
        }
    }

    func viewModelDidFailConnectionToPeripheral(_ wifiSelectDeviceViewModel: WiFiSelectDeviceViewModel) {
        DispatchQueue.main.async {
            HUD.hide()
        }
    }
}
