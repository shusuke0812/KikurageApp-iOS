//
//  RecipeBaseView.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2020/12/27.
//  Copyright © 2020 shusuke. All rights reserved.
//

import UIKit

class RecipeBaseView: UIView {
    @IBOutlet private(set) weak var tableView: UITableView!
    @IBOutlet private(set) weak var postPageButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        initUI()
        setTableView()
    }
}

// MARK: - Initialized Method

extension RecipeBaseView {
    private func initUI() {
        backgroundColor = .systemGroupedBackground
        tableView.backgroundColor = .systemGroupedBackground
        tableView.separatorStyle = .none
    }

    private func setTableView() {
        // セル選択を不可にする（料理記録詳細ページは無いため）
        tableView.allowsSelection = false
        // セル登録
        tableView.register(R.nib.recipeTableViewCell)
        tableView.tableFooterView = UIView()
    }
}

// MARK: - Config

extension RecipeBaseView {
    func setRefreshControlInTableView(_ refresh: UIRefreshControl) {
        tableView.refreshControl = refresh
    }

    func configTableView(delegate: UITableViewDelegate) {
        tableView.delegate = delegate
    }
}
