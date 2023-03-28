//
//  WiFiSettingViewController.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2023/3/5.
//  Copyright © 2023 shusuke. All rights reserved.
//

import PKHUD
import UIKit

class WiFiSettingViewController: UIViewController {
    private let baseView: WiFiSettingBaseView = .init()
    private let viewModel: WiFiSettingViewModel

    init(selectedSSID: String) {
        viewModel = WiFiSettingViewModel(selectedSSID: selectedSSID)
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

    private func setupProtocols() {
        baseView.setupTableViewProtocols(delegate: self, dataSource: viewModel)
        baseView.delegate = self
    }

    private func setupNavigation() {
        navigationItem.title = R.string.localizable.side_menu_wifi_setting_title()
    }

    private func showAlertWhenSettingCompletion(message: String) {
        UIAlertController.showAlert(
            viewController: self,
            message: message,
            okButtonTitle: R.string.localizable.common_alert_ok_btn_ok(),
            cancelButtonTitle: nil
        ) { [weak self] in
            self?.dismiss(animated: true)
        }
    }
}

// MARK: - UITableViewDelegate

extension WiFiSettingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = viewModel.sections[indexPath.section]
        let row = section.rows[indexPath.row]

        switch row {
        case .ssid, .password:
            // This action is declared in `WiFiSettingTableViewCell`.
            break
        case .activeScan:
            // TODO: open action sheet
            print()
        case .security:
            // TODO: open action sheet
            print()
        }
    }
}

// MARK: - WiFiSettingBaseViewDelegate

extension WiFiSettingViewController: WiFiSettingBaseViewDelegate {
    func wifiSettingBaseViewDidTappedSetting(_ wifiSettingBaseView: WiFiSettingBaseView) {
        HUD.show(.progress)
        viewModel.setupWiFi()
    }
}

// MARK: - WiFiSettingViewModelDelegate

extension WiFiSettingViewController: WiFiSettingViewModelDelegate {
    func wifiSettingViewModelDidSuccessSetting(_ wifiSettingViewModel: WiFiSettingViewModel) {
        DispatchQueue.main.async {
            HUD.hide()
            self.showAlertWhenSettingCompletion(message: R.string.localizable.side_menu_wifi_setting_success_alert_message())
        }
    }

    func wifiSettingViewModelDidFailSetting(_ wifiSettingViewModel: WiFiSettingViewModel) {
        DispatchQueue.main.async {
            HUD.hide()
            self.showAlertWhenSettingCompletion(message: R.string.localizable.side_menu_wifi_setting_fail_alert_message())
        }
    }

    func wifiSettingViewModel(_ wifiSettingViewModel: WiFiSettingViewModel, canSetWiFi: Bool) {
        DispatchQueue.main.async {
            self.baseView.enableSettingButton(isEnabled: canSetWiFi)
        }
    }
}
