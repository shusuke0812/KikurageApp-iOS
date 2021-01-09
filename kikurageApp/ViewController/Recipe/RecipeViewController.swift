//
//  recipeViewController.swift
//  kikurageApp
//
//  Created by Shusuke Ota on 2019/03/02.
//  Copyright © 2019 shusuke. All rights reserved.
//

import UIKit
import SafariServices

class RecipeViewController: UIViewController {
    // BaseView
    private var baseView: RecipeBaseView { self.view as! RecipeBaseView }
    // ViewModel
    private var viewModel: RecipeViewModel!
    // TableViewのセル高さ
    private let cellHeight: CGFloat = 160.0

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavigationItem()
        self.viewModel = RecipeViewModel(recipeRepository: RecipeRepository())
        self.setDelegateDataSource()
        self.viewModel.loadRecipes(kikurageUserId: LoginHelper.kikurageUserId!)
    }
}

// MARK: - Initialized Method
extension RecipeViewController {
    private func setNavigationItem() {
        self.setNavigationBar(title: "りょうりきろく")
    }
    private func setDelegateDataSource() {
        self.baseView.delegate = self
        self.baseView.tableView.delegate = self
        self.baseView.tableView.dataSource = self.viewModel
        self.viewModel.delegate = self
    }
}
// MARK: - RecipeBaseView Delegate Method
extension RecipeViewController: RecipeBaseViewDelegate {
    func didTapPostRecipePageButton() {
        let s = UIStoryboard(name: "PostRecipeViewController", bundle: nil)
        let vc = s.instantiateInitialViewController() as! PostRecipeViewController
        self.present(vc, animated: true, completion: nil)
    }
}
// MARK: - UITableView Delegate Method
extension RecipeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.cellHeight
    }
}
// MARK: - RecipeViewModel Method
extension RecipeViewController: RecipeViewModelDelegate {
    func didSuccessGetRecipes() {
        self.baseView.tableView.reloadData()
    }
    func didFailedGetRecipes(errorMessage: String) {
        print(errorMessage)
    }
}
