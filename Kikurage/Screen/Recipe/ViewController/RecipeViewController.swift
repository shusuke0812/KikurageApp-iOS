//
//  RecipeViewController.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2019/03/02.
//  Copyright © 2019 shusuke. All rights reserved.
//

import KAAnalytics
import KSRecipeService
import RxSwift
import UIKit

class RecipeViewController: UIViewController, UIViewControllerNavigatable, RecipeAccessable {
    private var viewModel: RecipeViewModelType!

    private let disposeBag = RxSwift.DisposeBag()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = RecipeViewModel()

        let baseView = RecipeBaseView(delegate: self, state: viewModel.state)
        addBaseView(baseView: baseView)

        setNavigationItem()
        setNotificationCenter()
        adjustNavigationBarBackgroundColor()

        loadRecipes()

        // RX
        rxBaseView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        FirebaseAnalyticsManager.sendScreenViewEvent(.recipe)
    }

    // MARK: - Action

    private func loadRecipes() {
        viewModel.state.isLoading = true
        viewModel.input.loadRecipes()
    }
}

// MARK: - Initialized

extension RecipeViewController {
    private func setNavigationItem() {
        setNavigationBar(title: R.string.localizable.screen_recipe_title())
    }
}

// MARK: - Rx

extension RecipeViewController {
    private func rxBaseView() {
        viewModel.output.recipes.subscribe(
            onNext: { [weak self] recipes in
                DispatchQueue.main.async {
                    self?.viewModel.state.isLoading = false
                    self?.viewModel.state.recipes = recipes
                }
            }
        )
        .disposed(by: disposeBag)

        viewModel.output.error.subscribe(
            onNext: { [weak self] _ in
                DispatchQueue.main.async {
                    // TODO: error.description()をアラートに表示させる
                    self?.viewModel.state.isLoading = false
                    self?.viewModel.state.hasError = true
                }
            }
        )
        .disposed(by: disposeBag)
    }
}

// MARK: - NotificationCenter

extension RecipeViewController {
    private func setNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(didPostRecipe), name: .updatedRecipes, object: nil)
    }

    @objc private func didPostRecipe(notification: Notification) {
        loadRecipes()
    }
}

// MARK: - RecipeBaseView Delegate

extension RecipeViewController: RecipeBaseViewDelegate {
    func recipeBaseViewDidTapAddButton() {
        modalToPostRecipe()
    }

    func recipeBaseViewDidPullToRefresh() {
        loadRecipes()
    }
}
