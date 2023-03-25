//
//  WiFiSettingBaseView.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2023/3/5.
//  Copyright © 2023 shusuke. All rights reserved.
//

import UIKit

protocol WiFiSettingBaseViewDelegate: AnyObject {
    func wifiSettingBaseViewDidTappedSetting(_ wifiSettingBaseView: WiFiSettingBaseView)
}

class WiFiSettingBaseView: UIView {
    private(set) var tableView = UITableView(frame: .zero, style: .insetGrouped)
    private let settingButton = UIButton()

    weak var delegate: WiFiSettingBaseViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupComponent()
        setupButtonAction()
    }

    required init?(coder: NSCoder) {
        nil
    }

    func setupTableViewProtocols(delegate: UITableViewDelegate, dataSource: UITableViewDataSource) {
        tableView.delegate = delegate
        tableView.dataSource = dataSource
    }

    private func setupComponent() {
        backgroundColor = .systemGroupedBackground

        tableView.register(WiFiSettingTableViewCell.self, forCellReuseIdentifier: "WiFiSettingTableViewCell")
        tableView.register(WiFiListTableViewCell.self, forCellReuseIdentifier: "WiFiListTableViewCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false

        settingButton.layer.masksToBounds = true
        settingButton.layer.cornerRadius = .buttonCornerRadius
        settingButton.backgroundColor = R.color.subColor()
        settingButton.setTitle(R.string.localizable.side_menu_wifi_setting_button_title(), for: .normal)
        settingButton.translatesAutoresizingMaskIntoConstraints = false

        addSubview(tableView)
        addSubview(settingButton)

        let buttonMargin: CGFloat = 16

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),

            settingButton.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: buttonMargin),
            settingButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: buttonMargin),
            settingButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -buttonMargin),
            settingButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -buttonMargin * 2),
            settingButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }

    private func setupButtonAction() {
        settingButton.addAction(.init { [weak self] _ in
            guard let self else {
                return
            }
            self.delegate?.wifiSettingBaseViewDidTappedSetting(self)
        }, for: .touchUpInside)
    }
}
