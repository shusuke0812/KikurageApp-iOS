//
//  RecipeBaseView.swift
//  kikurageApp
//
//  Created by Shusuke Ota on 2020/12/27.
//  Copyright © 2020 shusuke. All rights reserved.
//

import UIKit

protocol RecipeBaseViewDelegate: AnyObject {
    /// 料理記録保存画面のボタンをタップした時の処理
    func didTapPostRecipePageButton()
}

class RecipeBaseView: UIView {
    @IBOutlet weak var tableView: UITableView!
    /// デリゲート
    internal weak var delegate: RecipeBaseViewDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        self.setTableView()
    }
    // MARK: - Action Method
    @IBAction private func didTapPostRecipePageButton(_ sender: Any) {
        self.delegate?.didTapPostRecipePageButton()
    }
}
// MARK: - Initialized Method
extension RecipeBaseView {
    private func setTableView() {
        // セル選択を不可にする（料理記録詳細ページは無いため）
        self.tableView.allowsSelection = false
        // セル登録
        self.tableView.register(UINib(nibName: "RecipeTableViewCell", bundle: nil), forCellReuseIdentifier: "RecipeTableViewCell")
    }
}
