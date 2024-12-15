//
//  SideMenuBaseView.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2021/1/12.
//  Copyright © 2021 shusuke. All rights reserved.
//

import KikurageUI
import UIKit

class SideMenuBaseView: UIView {
    private(set) var sideMenuParentView: UIView!
    private var titleLabel: UILabel!
    private(set) var tableView: UITableView!
    private var headerHeightConstraint: NSLayoutConstraint!

    private let sideMenuParentViewWidth: CGFloat = 210

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupComponent()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupComponent() {
        frame.origin.x = -sideMenuParentViewWidth
        backgroundColor = .white.withAlphaComponent(0.5)

        sideMenuParentView = UIView()
        sideMenuParentView.backgroundColor = R.color.themeColor()
        sideMenuParentView.translatesAutoresizingMaskIntoConstraints = false

        titleLabel = UILabel()
        titleLabel.font = .systemFont(ofSize: 18, weight: .bold)
        titleLabel.contentMode = .left
        titleLabel.text = R.string.localizable.side_menu_title()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        let headerView = UIView()
        headerView.backgroundColor = .systemBackground
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(titleLabel)

        tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = .systemGroupedBackground
        tableView.isScrollEnabled = false
        tableView.register(KUISideMenuItemTableViewCell.self, forCellReuseIdentifier: KUISideMenuItemTableViewCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false

        sideMenuParentView.addSubview(headerView)
        sideMenuParentView.addSubview(tableView)

        addSubview(sideMenuParentView)

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 15),
            titleLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -15),
            titleLabel.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -10),
        ])

        NSLayoutConstraint.activate([
            sideMenuParentView.widthAnchor.constraint(equalToConstant: sideMenuParentViewWidth),
            sideMenuParentView.topAnchor.constraint(equalTo: topAnchor),
            sideMenuParentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            sideMenuParentView.bottomAnchor.constraint(equalTo: bottomAnchor),

            // Header
            headerView.heightAnchor.constraint(equalToConstant: 87),
            headerView.topAnchor.constraint(equalTo: sideMenuParentView.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: sideMenuParentView.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: sideMenuParentView.trailingAnchor),

            // Body
            tableView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: sideMenuParentView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: sideMenuParentView.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: sideMenuParentView.bottomAnchor)
        ])
    }
}

// MARK: - Config

extension SideMenuBaseView {
    func initHeaderHeightConstraint() {
        let navBarHeight = AppConfig.shared.navigationBarHeight ?? 0
        let safeAreaHeight = AppConfig.shared.safeAreaHeight ?? 0
        headerHeightConstraint.constant = navBarHeight + safeAreaHeight
    }

    func configTableView(delegate: UITableViewDelegate, dataSource: UITableViewDataSource) {
        tableView.delegate = delegate
        tableView.dataSource = dataSource
    }

    func closeAnimations() {
        layer.position.x = -frame.width
    }

    func openAnimations() {
        frame.origin.x = 0
    }
}
