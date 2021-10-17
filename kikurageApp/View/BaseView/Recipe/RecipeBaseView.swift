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
    @IBOutlet weak var noRecipeLabel: UILabel!

    weak var delegate: RecipeBaseViewDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        initUI()
        setTableView()
    }
    // MARK: - Action
    @IBAction private func didTapPostRecipePageButton(_ sender: Any) {
        delegate?.didTapPostRecipePageButton()
    }
}
// MARK: - Initialized Method
extension RecipeBaseView {
    private func initUI() {
        noRecipeLabel.text = "りょうりきろくがありません"
        noRecipeLabel.textColor = .darkGray
        noRecipeLabel.isHidden = true
    }
    private func setTableView() {
        // セル選択を不可にする（料理記録詳細ページは無いため）
        tableView.allowsSelection = false
        // セル登録
        tableView.register(R.nib.recipeTableViewCell)
        tableView.tableFooterView = UIView()
    }
}
