//
//  WiFiListBaseView.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2023/3/5.
//  Copyright © 2023 shusuke. All rights reserved.
//

import KikurageFeature
import UIKit

class WiFiListBaseView: UIView {
    private(set) var tableView = UITableView(frame: .zero, style: .insetGrouped)
    private(set) var tableViewHeaderView: KikurageTableViewHeaderView!

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

    func setupTableViewHeaderView(_ headerView: KikurageTableViewHeaderView, sectionNumber: Int) {
        tableViewHeaderView = headerView
        tableViewHeaderView.sectionNumber = sectionNumber
    }

    private func setupComponent() {
        tableView.register(WiFiListSpecTableViewCell.self, forCellReuseIdentifier: "WiFiListSpecTableViewCell")
        tableView.register(WiFiListTableViewCell.self, forCellReuseIdentifier: "WiFiListTableViewCell")
        tableView.register(KikurageTableViewHeaderView.self, forHeaderFooterViewReuseIdentifier: KikurageTableViewHeaderView.indetifier)
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
