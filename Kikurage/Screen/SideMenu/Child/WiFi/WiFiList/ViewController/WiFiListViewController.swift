//
//  WiFiListViewController.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2023/3/5.
//  Copyright © 2023 shusuke. All rights reserved.
//

import UIKit

class WiFiListViewController: UIViewController, UIViewControllerNavigatable, WiFiAccessable {
    private let viewModel = WiFiListViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()

        let baseView = WiFiListBaseView(state: viewModel.state, delegate: self)
        let _ = addBaseView(baseView: baseView)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.delegate = self
        viewModel.bluetoothDelegate()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.startWiFiScan()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewModel.stopWiFiScan()
    }

    override func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent: parent)
        // 戻るボタンタップ等でこの画面がナビゲーションスタックから外れた場合、選択中デバイスとのBLE接続を切断する
        if parent == nil {
            viewModel.disconnectPeripheral()
        }
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
