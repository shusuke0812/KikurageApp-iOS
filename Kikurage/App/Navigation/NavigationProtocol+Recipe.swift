//
//  NavigationProtocol+Recipe.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2022/3/12.
//  Copyright © 2022 shusuke. All rights reserved.
//

import UIKit

protocol RecipeAccessable: PushNavigationProtocol, ModalNavigationProtocol {
    func pushToRecipe()
    func modalToPostRecipe()
}

extension RecipeAccessable {
    // MARK: - Push

    func pushToRecipe() {
        guard let vc = R.storyboard.recipeViewController.instantiateInitialViewController() else { return }
        push(to: vc)
    }

    // MARK: - Modal

    func modalToPostRecipe() {
        guard let vc = R.storyboard.postRecipeViewController.instantiateInitialViewController() else { return }
        present(to: vc, style: .automatic)
    }
}
