//
//  recipeViewController.swift
//  kikurageApp
//
//  Created by Shusuke Ota on 2019/03/02.
//  Copyright © 2019 shusuke. All rights reserved.
//

import UIKit
import SafariServices
import PKHUD

class RecipeViewController: UIViewController, UIViewControllerNavigatable {
    private var baseView: RecipeBaseView { self.view as! RecipeBaseView } // swiftlint:disable:this force_cast
    private var viewModel: RecipeViewModel!

    private let cellHeight: CGFloat = 160.0

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationItem()
        viewModel = RecipeViewModel(recipeRepository: RecipeRepository())
        setDelegateDataSource()
        setNotificationCenter()
        if let kikurageUserId = LoginHelper.shared.kikurageUserId {
            HUD.show(.progress)
            viewModel.loadRecipes(kikurageUserId: kikurageUserId)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}

// MARK: - Initialized
extension RecipeViewController {
    private func setNavigationItem() {
        setNavigationBar(title: "りょうりきろく")
    }
    private func setDelegateDataSource() {
        baseView.delegate = self
        baseView.tableView.delegate = self
        baseView.tableView.dataSource = viewModel
        viewModel.delegate = self
    }
}
// MARK: - RecipeBaseView Delegate
extension RecipeViewController: RecipeBaseViewDelegate {
    func didTapPostRecipePageButton() {
        guard let vc = R.storyboard.postRecipeViewController.instantiateInitialViewController() else { return }
        present(vc, animated: true, completion: nil)
    }
}
// MARK: - UITableView Delegate
extension RecipeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        cellHeight
    }
}
// MARK: - RecipeViewModel
extension RecipeViewController: RecipeViewModelDelegate {
    func didSuccessGetRecipes() {
        DispatchQueue.main.async {
            HUD.hide()
            self.baseView.tableView.reloadData()
            self.baseView.noRecipeLabel.isHidden = !(self.viewModel.recipes.isEmpty)
        }
    }
    func didFailedGetRecipes(errorMessage: String) {
        print(errorMessage)
        DispatchQueue.main.async {
            HUD.hide()
        }
    }
}

// MARK: - NotificationCenter
extension RecipeViewController {
    private func setNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(didPostRecipe), name: .updatedRecipes, object: nil)
    }
    @objc private func didPostRecipe(notification: Notification) {
        if let kikurageUserId = LoginHelper.shared.kikurageUserId {
            viewModel.loadRecipes(kikurageUserId: kikurageUserId)
        }
    }
}
