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
import RxSwift

class RecipeViewController: UIViewController, UIViewControllerNavigatable, RecipeAccessable {
    private var baseView: RecipeBaseView { self.view as! RecipeBaseView } // swiftlint:disable:this force_cast
    private var viewModel: RecipeViewModel!

    private let diposeBag = RxSwift.DisposeBag()
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

        // Rx
        rxBaseView()
        rxTransition()
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
        baseView.configTableView(delegate: self)
    }
    private func setRefreshControl() {
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        baseView.setRefreshControlInTableView(refresh)
    }
}

// MARK: - Rx

extension RecipeViewController {
    private func rxBaseView() {
        viewModel.output.recipes.bind(to: baseView.tableView.rx.items) { tableview, row, element in
            let indexPath = NSIndexPath(row: row, section: 0) as IndexPath
            let cell = tableview.dequeueReusableCell(withIdentifier: R.reuseIdentifier.recipeTableViewCell, for: indexPath)! // swiftlint:disable:this force_unwrapping
            cell.setUI(recipe: element.data)
            return cell
        }
        .disposed(by: diposeBag)

        viewModel.output.recipes.subscribe(
            onNext: { [weak self] recipes in
                DispatchQueue.main.async {
                    HUD.hide()
                    self?.baseView.tableView.refreshControl?.endRefreshing()
                    self?.baseView.tableView.reloadData()
                    self?.baseView.noRecipeLabelIsHidden(!recipes.isEmpty)
                }
            }, onError: { error in
                DispatchQueue.main.async {
                    HUD.hide()
                    self.baseView.tableView.refreshControl?.endRefreshing()

                    let error = error as! ClientError // swiftlint:disable:this force_cast
                    UIAlertController.showAlert(style: .alert, viewController: self, title: error.description(), message: nil, okButtonTitle: R.string.localizable.common_alert_ok_btn_ok(), cancelButtonTitle: nil, completionOk: nil)
                }
            }
        )
        .disposed(by: diposeBag)

        // MEMO: item on table view selected（nothing）
    }
    private func rxTransition() {
        baseView.postPageButton.rx.tap.asDriver()
            .drive(
                onNext: { [weak self] in
                    self?.modalToPostRecipe()
                }
            )
            .disposed(by: diposeBag)

        // MEMO: subscrive to selected item on table view（nothing）
    }
}

// MARK: - UITableView Delegate

extension RecipeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        cellHeight
    }
}

// MARK: - NotificationCenter

extension RecipeViewController {
    private func setNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(didPostRecipe), name: .updatedRecipes, object: nil)
    }
    @objc private func didPostRecipe(notification: Notification) {
        if let kikurageUserId = LoginHelper.shared.kikurageUserId {
            HUD.show(.progress)
            viewModel.loadRecipes(kikurageUserId: kikurageUserId)
        }
    }
}
