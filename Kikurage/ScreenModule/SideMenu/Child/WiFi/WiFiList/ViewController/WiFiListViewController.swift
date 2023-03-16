//
//  WiFiListViewController.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2023/3/5.
//  Copyright © 2023 shusuke. All rights reserved.
//

import UIKit
import KikurageFeature

class WiFiListViewController: UIViewController {
    private let baseView = WiFiListBaseView()
    private let viewModel: WiFiListViewModel

    init(bluetoothPeriperal: KikurageBluetoothPeripheral) {
        self.viewModel = WiFiListViewModel(bluetoothPeripheral: bluetoothPeriperal)
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

    private func setupNavigation() {
        navigationItem.title = R.string.localizable.side_menu_wifi_list_title()
    }

    private func setupProtocols() {
        baseView.setupTableViewProtocols(delegate: self, dataSource: viewModel)
    }
}

// MARK: - UITableViewDelegate

extension WiFiListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}

// MARK: - WiFiListViewModelDelegate

extension WiFiListViewController: WiFiListViewModelDelegate {
    func viewModelUpdateWiFiList(_ wifiListViewModel: WiFiListViewModel) {
        DispatchQueue.main.async {
            self.baseView.tableView.reloadData()
        }
    }
}
