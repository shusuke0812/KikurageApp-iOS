//
//  WiFiSettingViewController.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2023/3/5.
//  Copyright © 2023 shusuke. All rights reserved.
//

import UIKit

class WiFiSettingViewController: UIViewController, UIViewControllerNavigatable {
    private let viewModel: WiFiSettingViewModel

    init(selectedSSID: String) {
        viewModel = WiFiSettingViewModel(selectedSSID: selectedSSID)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()

        let baseView = WiFiSettingBaseView(state: viewModel.state, delegate: self)
        let _ = addBaseView(baseView: baseView)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.delegate = self
        viewModel.bluetoothDelegate()
    }

    private func setupNavigation() {
        navigationItem.title = R.string.localizable.side_menu_wifi_setting_title()
    }
}

// MARK: - WiFiSettingBaseView Delegate

extension WiFiSettingViewController: WiFiSettingBaseViewDelegate {
    func wifiSettingBaseViewDidTapSetting() {
        viewModel.setupWiFi()
    }

    func wifiSettingBaseViewDidConfirmAlert() {
        dismiss(animated: true)
    }
}

// MARK: - WiFiSettingViewModelDelegate

extension WiFiSettingViewController: WiFiSettingViewModelDelegate {
    func wifiSettingViewModelDidSuccessSetting(_ wifiSettingViewModel: WiFiSettingViewModel) {
        DispatchQueue.main.async { [weak self] in
            self?.viewModel.state.alert = .success(message: R.string.localizable.side_menu_wifi_setting_success_alert_message())
        }
    }

    func wifiSettingViewModelDidFailSetting(_ wifiSettingViewModel: WiFiSettingViewModel) {
        DispatchQueue.main.async { [weak self] in
            self?.viewModel.state.alert = .failure(message: R.string.localizable.side_menu_wifi_setting_fail_alert_message())
        }
    }
}
