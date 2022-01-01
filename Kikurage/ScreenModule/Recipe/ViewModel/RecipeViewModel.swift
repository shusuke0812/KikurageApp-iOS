//
//  RecipeViewModel.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2020/12/27.
//  Copyright © 2020 shusuke. All rights reserved.
//

import UIKit.UITableView

protocol RecipeViewModelDelegate: AnyObject {
    /// きくらげ料理記録の取得に成功した
    func didSuccessGetRecipes()
    /// きくらげ料理記録の取得に失敗した
    func didFailedGetRecipes(errorMessage: String)
}

class RecipeViewModel: NSObject {
    private let recipeRepository: RecipeRepositoryProtocol

    weak var delegate: RecipeViewModelDelegate?
    ///　きくらげ料理データ
    var recipes: [(recipe: KikurageRecipe, documentId: String)] = []

    private let sectionNumber = 1

    init(recipeRepository: RecipeRepositoryProtocol) {
        self.recipeRepository = recipeRepository
    }
}

// MARK: - Data Setting

extension RecipeViewModel {
    private func sortRecipes() {
        recipes.sort { recipe1, recipe2 -> Bool in
            guard let recipeDate1 = DateHelper.formatToDate(dateString: recipe1.recipe.cookDate) else { return false }
            guard let recipeDate2 = DateHelper.formatToDate(dateString: recipe2.recipe.cookDate) else { return false }
            return recipeDate1 > recipeDate2
        }
    }
}

// MARK: - Firebase Firestore

extension RecipeViewModel {
    /// きくらげ料理記録を読み込む
    func loadRecipes(kikurageUserId: String) {
        recipeRepository.getRecipes(kikurageUserId: kikurageUserId) { [weak self] response in
            switch response {
            case .success(let recipes):
                self?.recipes = recipes
                self?.sortRecipes()
                self?.delegate?.didSuccessGetRecipes()
            case .failure(let error):
                self?.delegate?.didFailedGetRecipes(errorMessage: error.description())
            }
        }
    }
}

// MARK: - UITableView DataSource

extension RecipeViewModel: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        sectionNumber
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        recipes.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.recipeTableViewCell, for: indexPath)! // swiftlint:disable:this force_unwrapping
        cell.setUI(recipe: recipes[indexPath.row].recipe)
        return cell
    }
}
