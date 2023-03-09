//
//  WiFiListViewController.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2023/3/5.
//  Copyright © 2023 shusuke. All rights reserved.
//

import UIKit

class WiFiListViewController: UIViewController {
    private let baseView = WiFiListBaseView()
    private let viewModel = WiFiListViewModel()

    override func loadView() {
        view = baseView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupProtocols()
        setupNavigation()
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
