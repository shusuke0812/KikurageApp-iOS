//
//  RecipeTableViewCell.swift
//  kikurageApp
//
//  Created by Shusuke Ota on 2021/1/3.
//  Copyright © 2021 shusuke. All rights reserved.
//

import UIKit

class RecipeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var recipeDateLabel: UILabel!
    @IBOutlet weak var recipeNameLabel: UILabel!
    @IBOutlet weak var recipeMemoLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initUI()
    }
}
// MARK: - Initialized Method
extension RecipeTableViewCell {
    private func initUI() {
        self.recipeDateLabel.text = ""
        self.recipeNameLabel.text = ""
        self.recipeMemoLabel.text = ""
    }
}
