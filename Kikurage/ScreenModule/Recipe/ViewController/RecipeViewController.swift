//
//  recipeViewController.swift
//  Kikurage
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
        setRefreshControl()

        adjustNavigationBarBackgroundColor()

        if let kikurageUserId = LoginHelper.shared.kikurageUserId {
            HUD.show(.progress)
            viewModel.loadRecipes(kikurageUserId: kikurageUserId)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    // MARK: - Action

    @objc private func refresh(_ sender: UIRefreshControl) {
        if let kikurageUserId = LoginHelper.shared.kikurageUserId {
            viewModel.loadRecipes(kikurageUserId: kikurageUserId)
        }
    }
}

// MARK: - Initialized

extension RecipeViewController {
    private func setNavigationItem() {
        setNavigationBar(title: R.string.localizable.screen_recipe_title())
    }
    private func setDelegateDataSource() {
        baseView.delegate = self
        baseView.tableView.delegate = self
        baseView.tableView.dataSource = viewModel
        viewModel.delegate = self
    }
    private func setRefreshControl() {
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        baseView.setRefreshControlInTableView(refresh)
    }
}

// MARK: - RecipeBaseView Delegate

extension RecipeViewController: RecipeBaseViewDelegate {
    func recipeBaseViewDidTapPostRecipePageButton(_ recipeBaseView: RecipeBaseView) {
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

// MARK: - RecipeViewModel Delegate

extension RecipeViewController: RecipeViewModelDelegate {
    func recipeViewModelDidSuccessGetRecipes(_ recipeViewModel: RecipeViewModel) {
        DispatchQueue.main.async {
            HUD.hide()
            self.baseView.tableView.refreshControl?.endRefreshing()

            self.baseView.tableView.reloadData()
            self.baseView.noRecipeLabel.isHidden = !(recipeViewModel.recipes.isEmpty)
        }
    }
    func recipeViewModelDidFailedGetRecipes(_ recipeViewModel: RecipeViewModel, with errorMessage: String) {
        DispatchQueue.main.async {
            HUD.hide()
            self.baseView.tableView.refreshControl?.endRefreshing()

            UIAlertController.showAlert(style: .alert, viewController: self, title: errorMessage, message: nil, okButtonTitle: R.string.localizable.common_alert_ok_btn_ok(), cancelButtonTitle: nil, completionOk: nil)
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
