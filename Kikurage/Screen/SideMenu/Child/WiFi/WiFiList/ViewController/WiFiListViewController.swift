//
//  WiFiListViewController.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2023/3/5.
//  Copyright © 2023 shusuke. All rights reserved.
//

import KSWiFiService
import UIKit

class WiFiListViewController: UIViewController, UIViewControllerNavigatable, WiFiAccessable {
    private let viewModel = WiFiListViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        viewModel.delegate = self

        let baseView = WiFiListBaseView(state: viewModel.state, delegate: self)
        let _ = addBaseView(baseView: baseView)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.startWiFiScan()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewModel.stopWiFiScan()
    }

    private func setupNavigation() {
        navigationItem.title = R.string.localizable.side_menu_wifi_list_title()
    }
}

// MARK: - WiFiListBaseView Delegate

extension WiFiListViewController: WiFiListBaseViewDelegate {
    func wifiListBaseViewDidSelectWiFi(ssid: String) {
        pushToWiFiSetting(selectedSSID: ssid)
    }
}

// MARK: - WiFiListViewModelDelegate

extension WiFiListViewController: WiFiListViewModelDelegate {
    func viewModelUpdateWiFiList(_ wifiListViewModel: WiFiListViewModel) {}
}
