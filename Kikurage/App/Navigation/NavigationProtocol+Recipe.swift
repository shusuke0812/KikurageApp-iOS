//
//  NavigationProtocol+Recipe.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2022/3/12.
//  Copyright © 2022 shusuke. All rights reserved.
//

import UIKit

protocol RecipeAccessable: PushNavigationProtocol, ModalNavigationProtocol {
    func modalToPostRecipe()
}

extension RecipeAccessable {
    // MARK: - Modal

    func modalToPostRecipe() {
        let vc = PostRecipeViewController()
        present(to: vc, presentationStyle: .automatic)
    }
}
