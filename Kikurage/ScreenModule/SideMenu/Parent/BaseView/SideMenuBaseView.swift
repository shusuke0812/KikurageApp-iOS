//
//  SideMenuBaseView.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2021/1/12.
//  Copyright © 2021 shusuke. All rights reserved.
//

import UIKit

class SideMenuBaseView: UIView {
    @IBOutlet private(set) weak var sideMenuParentView: UIView!
    @IBOutlet private(set) weak var tableView: UITableView!
    @IBOutlet private weak var headerHeightConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        registerTableViewCell()
        initUI()
        initHeaderHeightConstraint()
    }
}

// MARK: - Config

extension SideMenuBaseView {
    private func initUI() {
        tableView.backgroundColor = .systemGroupedBackground
        tableView.isScrollEnabled = false
    }
    private func registerTableViewCell() {
        let nib = UINib(nibName: "SideMenuTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "SideMenuTableViewCell")
    }
    func initHeaderHeightConstraint() {
        let navBarHeight = AppConfig.shared.navigationBarHeight ?? 0
        let safeAreaHeight = AppConfig.shared.safeAreaHeight ?? 0
        headerHeightConstraint.constant = navBarHeight + safeAreaHeight
    }
    func configTableView(delegate: UITableViewDelegate, dataSource: UITableViewDataSource) {
        tableView.delegate = delegate
        tableView.dataSource = dataSource
    }
    func animations() {
        layer.position.x = -frame.width
    }
}
