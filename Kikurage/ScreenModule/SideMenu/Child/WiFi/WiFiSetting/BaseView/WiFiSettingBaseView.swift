//
//  WiFiSettingBaseView.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2023/3/5.
//  Copyright © 2023 shusuke. All rights reserved.
//

import UIKit

class WiFiSettingBaseView: UIView {
    private(set) var tableView = UITableView(frame: .zero, style: .insetGrouped)

    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupComponent()
    }

    required init?(coder: NSCoder) {
        nil
    }

    func setupTableViewProtocols(delegate: UITableViewDelegate, dataSource: UITableViewDataSource) {
        tableView.delegate = delegate
        tableView.dataSource = dataSource
    }

    private func setupComponent() {
        tableView.register(WiFiSettingTableViewCell.self, forCellReuseIdentifier: "WiFiSettingTableViewCell")
        tableView.register(WiFiListTableViewCell.self, forCellReuseIdentifier: "WiFiListTableViewCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
