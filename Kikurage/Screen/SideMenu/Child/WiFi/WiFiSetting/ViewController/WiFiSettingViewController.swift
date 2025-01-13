//
//  WiFiSettingViewController.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2023/3/5.
//  Copyright © 2023 shusuke. All rights reserved.
//

import KSWiFiService
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
        baseView.setupTableViewProtocols(delegate: self, dataSource: self)
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

// MARK: - UITableViewDataSource

extension WiFiSettingViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.sections.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        viewModel.sections[section].title
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.sectionRows(section: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = viewModel.sections[indexPath.section]
        let row = section.rows[indexPath.row]
        switch section {
        case .required:
            let cell = tableView.dequeueReusableCell(withIdentifier: "WiFiSettingTableViewCell", for: indexPath) as! WiFiSettingTableViewCell // swiftlint:disable:this force_cast
            cell.updateComponent(title: row.title)
            cell.type = row
            cell.delegate = self
            if row == .ssid {
                cell.updateComponent(textFieldText: viewModel.wifiSetting.ssid)
            }
            return cell
        case .optional:
            let cell = tableView.dequeueReusableCell(withIdentifier: "WiFiListTableViewCell", for: indexPath) as! WiFiListTableViewCell // swiftlint:disable:this force_cast
            cell.updateComponent(title: row.title)
            return cell
        }
    }
}

// MARK: - WiFiSettingTableViewCellDelegate

extension WiFiSettingViewController: WiFiSettingTableViewCellDelegate {
    public func wifiSettingTableViewCell(_ wifiSettingTableViewCell: WiFiSettingTableViewCell, didEnter text: String) {
        switch wifiSettingTableViewCell.type {
        case .ssid:
            viewModel.updateWiFiSetting(ssid: text)
        case .password:
            viewModel.updateWiFiSetting(password: text)
        case .activeScan, .security:
            break // never called
        }
        DispatchQueue.main.async {
            self.baseView.enableSettingButton(isEnabled: self.viewModel.validateWiFiSetting())
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
