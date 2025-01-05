//
//  WiFiListViewController.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2023/3/5.
//  Copyright © 2023 shusuke. All rights reserved.
//

import KSWiFiService
import KUIKit
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
        baseView.setupTableViewProtocols(delegate: self, dataSource: self)
    }

    private func transitionToWiFiSetting(selectedSSID: String) {
        pushToWiFiSetting(selectedSSID: selectedSSID)
    }
}

// MARK: - UITableViewDelegate

extension WiFiListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        baseView.setupTableViewHeaderView(KUITableHeaderView.create(tableView: tableView), sectionNumber: section)
        baseView.tableViewHeaderView.setupTitleLabel(viewModel.sections[section].title)
        return baseView.tableViewHeaderView
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let ssid = viewModel.getSelectedSSID(indexPath: indexPath)
        transitionToWiFiSetting(selectedSSID: ssid)
    }
}

// MARK: - UITableViewDataSource

extension WiFiListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.sectionRows(section: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = viewModel.sections[indexPath.section]
        switch section {
        case .spec:
            let cell = tableView.dequeueReusableCell(withIdentifier: "WiFiListSpecTableViewCell", for: indexPath) as! WiFiListSpecTableViewCell // swiftlint:disable:this force_cast
            cell.updateComponent(title: section.rows[indexPath.row].title)
            cell.updateComponent(stateTitle: section.rows[indexPath.row].getSpecTitle(bluetoothPeripheral: bluetoothPeripheral))
            return cell
        case .enterWifi:
            let cell = tableView.dequeueReusableCell(withIdentifier: "WiFiListTableViewCell", for: indexPath) as! WiFiListTableViewCell // swiftlint:disable:this force_cast
            cell.updateComponent(title: section.rows[indexPath.row].title)
            return cell
        case .selectWifi:
            let cell = tableView.dequeueReusableCell(withIdentifier: "WiFiListTableViewCell", for: indexPath) as! WiFiListTableViewCell // swiftlint:disable:this force_cast
            cell.updateComponent(title: viewModel.wifiList.getWiFiTitle(indexPath: indexPath))
            return cell
        }
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
