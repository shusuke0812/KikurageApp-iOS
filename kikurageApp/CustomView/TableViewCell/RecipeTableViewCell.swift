//
//  RecipeTableViewCell.swift
//  kikurageApp
//
//  Created by Shusuke Ota on 2021/1/3.
//  Copyright © 2021 shusuke. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

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
// MARK: - Setting UI Method
extension RecipeTableViewCell {
    func setUI(recipe: KikurageRecipe) {
        self.recipeDateLabel.text = recipe.cookDate
        self.recipeNameLabel.text = recipe.name
        self.recipeMemoLabel.text = recipe.memo
        
        guard let imageStoragePath = recipe.imageStoragePaths.first else { return }
        if !imageStoragePath.isEmpty {
            let storageReference = Storage.storage().reference(withPath: imageStoragePath)
            self.recipeImageView.sd_setImage(with: storageReference, placeholderImage: UIImage(named: "loading"))
        }
    }
}
