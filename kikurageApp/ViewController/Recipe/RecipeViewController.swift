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
    // BaseView
    private var baseView: RecipeBaseView { self.view as! RecipeBaseView } // swiftlint:disable:this force_cast
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
        self.setNotificationCenter()
        if let kikurageUserId = LoginHelper.shared.kikurageUserId {
            HUD.show(.progress)
            self.viewModel.loadRecipes(kikurageUserId: kikurageUserId)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}

// MARK: - Initialized
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
// MARK: - RecipeBaseView Delegate
extension RecipeViewController: RecipeBaseViewDelegate {
    func didTapPostRecipePageButton() {
        guard let vc = R.storyboard.postRecipeViewController.instantiateInitialViewController() else { return }
        self.present(vc, animated: true, completion: nil)
    }
}
// MARK: - UITableView Delegate
extension RecipeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        self.cellHeight
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
            self.viewModel.loadRecipes(kikurageUserId: kikurageUserId)
        }
    }
}
