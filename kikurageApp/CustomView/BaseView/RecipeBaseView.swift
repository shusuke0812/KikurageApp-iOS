//
//  RecipeBaseView.swift
//  kikurageApp
//
//  Created by Shusuke Ota on 2020/12/27.
//  Copyright © 2020 shusuke. All rights reserved.
//

import UIKit

protocol RecipeBaseViewDelegate: class {
    /// 料理記録保存画面のボタンをタップした時の処理
    func didTapPostRecipePageButton()
}

class RecipeBaseView: UIView {

    @IBOutlet weak var tableView: UITableView!
    /// デリゲート
    internal weak var delegate: RecipeBaseViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    // MARK: - Action Method
    @IBAction func didTapPostRecipePageButton(_ sender: Any) {
        self.delegate?.didTapPostRecipePageButton()
    }
}
// MARK: - Initialized Method
extension RecipeBaseView {
}
