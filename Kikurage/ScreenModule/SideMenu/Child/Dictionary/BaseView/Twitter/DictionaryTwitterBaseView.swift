//
//  DictionaryTwitterBaseView.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2022/4/2.
//  Copyright © 2022 shusuke. All rights reserved.
//

import UIKit

class DictionaryTwitterBaseView: UIView {
    @IBOutlet private weak var tableView: UITableView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

// MARK: - Config

extension DictionaryTwitterBaseView {
    func configTableView(delegate: UITableViewDelegate, dataSource: UITableViewDataSource) {
        tableView.delegate = delegate
        tableView.dataSource = dataSource
    }
}
