//
//  WiFiListViewController.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2023/3/5.
//  Copyright © 2023 shusuke. All rights reserved.
//

import KikurageFeature
import UIKit

class WiFiListViewController: UIViewController, WiFiAccessable {
    private let baseView = WiFiListBaseView()
    private let viewModel: WiFiListViewModel

    init(bluetoothPeriperal: KikurageBluetoothPeripheral) {
        viewModel = WiFiListViewModel(bluetoothPeripheral: bluetoothPeriperal)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        nil
    }

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
        if let wifiSelectSection = viewModel.sections.firstIndex(of: .selectWifi), wifiSelectSection == baseView.tableViewHeaderView.sectionNumber {
            baseView.tableViewHeaderView.startIndicatorAnimating()
        }
        viewModel.startWiFiScan()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewModel.stopWiFiScan()
    }

    private func setupNavigation() {
        navigationItem.title = R.string.localizable.side_menu_wifi_list_title()
    }

    private func setupProtocols() {
        baseView.setupTableViewProtocols(delegate: self, dataSource: viewModel)
    }

    private func transitionToWiFiSetting(selectedSSID: String) {
        pushToWiFiSetting(selectedSSID: selectedSSID)
    }
}

// MARK: - UITableViewDelegate

extension WiFiListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        baseView.setupTableViewHeaderView(KikurageTableViewHeaderView.create(tableView: tableView), sectionNumber: section)
        baseView.tableViewHeaderView.setupTitleLabel(viewModel.sections[section].title)
        return baseView.tableViewHeaderView
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let ssid = viewModel.getSelectedSSID(indexPath: indexPath)
        transitionToWiFiSetting(selectedSSID: ssid)
    }
}

// MARK: - WiFiListViewModelDelegate

extension WiFiListViewController: WiFiListViewModelDelegate {
    func viewModelUpdateWiFiList(_ wifiListViewModel: WiFiListViewModel) {
        DispatchQueue.main.async {
            self.baseView.tableViewHeaderView.stopIndicatorAnimating()
            self.baseView.tableView.reloadData()
        }
    }
}
