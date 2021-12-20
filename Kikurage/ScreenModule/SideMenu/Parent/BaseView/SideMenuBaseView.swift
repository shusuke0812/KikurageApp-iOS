//
//  SideMenuBaseView.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2021/1/12.
//  Copyright © 2021 shusuke. All rights reserved.
//

import UIKit

class SideMenuBaseView: UIView {
    @IBOutlet private weak var sideMenuParentView: UIView!
    @IBOutlet private weak var tableView: UITableView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

// MARK: - Config

extension SideMenuBaseView {
    func configTableView(delegate: UITableViewDelegate, dataSource: UITableViewDataSource) {
        tableView.delegate = delegate
        tableView.dataSource = dataSource
    }
}
