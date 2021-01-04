//
//  RecipeViewModel.swift
//  kikurageApp
//
//  Created by Shusuke Ota on 2020/12/27.
//  Copyright © 2020 shusuke. All rights reserved.
//

import UIKit

protocol RecipeViewModelDelegate: class {
    /// きくらげ料理記録の取得に成功した
    func didSuccessGetRecipes()
    /// きくらげ料理記録の取得に失敗した
    func didFailedGetRecipes(errorMessage: String)
}

class RecipeViewModel: NSObject {
    /// デリゲート
    internal var delegate: RecipeViewModelDelegate?
    ///　きくらげ料理データ
    var recipes: [(recipe: KikurageRecipe, documentId: String)] = []
    
}
// MARK: - Firebase Firestore Method
extension RecipeViewModel {
    
}
// MARK: - UITableView DataSource
extension RecipeViewModel: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.recipes.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeTableViewCell", for: indexPath) as! RecipeTableViewCell
        return cell
    }
}
