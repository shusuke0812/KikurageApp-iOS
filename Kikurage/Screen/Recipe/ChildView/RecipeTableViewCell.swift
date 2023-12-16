//
//  RecipeTableViewCell.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2021/1/3.
//  Copyright © 2021 shusuke. All rights reserved.
//

import Firebase
import FirebaseFirestore
import UIKit

class RecipeTableViewCell: UITableViewCell {
    @IBOutlet private weak var parentView: UIView!
    @IBOutlet private weak var thumbnailParentView: UIView!

    @IBOutlet private weak var recipeImageView: UIImageView!
    @IBOutlet private weak var recipeDateLabel: UILabel!
    @IBOutlet private weak var recipeNameLabel: UILabel!
    @IBOutlet private weak var recipeMemoLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        initUI()
    }
}

// MARK: - Initialized

extension RecipeTableViewCell {
    private func initUI() {
        parentView.clipsToBounds = true
        parentView.layer.cornerRadius = .cellCornerRadius

        thumbnailParentView.clipsToBounds = true
        thumbnailParentView.layer.cornerRadius = .cellCornerRadius
    }
}

// MARK: - Setting UI

extension RecipeTableViewCell {
    func setUI(recipe: KikurageRecipe) {
        recipeDateLabel.text = recipe.cookDate
        recipeNameLabel.text = recipe.name
        recipeMemoLabel.text = recipe.memo

        guard let imageStoragePath = recipe.imageStoragePaths.first else {
            return
        }
        if !imageStoragePath.isEmpty {
            let storageReference = Storage.storage().reference(withPath: imageStoragePath)
            recipeImageView.sd_setImage(with: storageReference, placeholderImage: nil)
        }
    }
}
