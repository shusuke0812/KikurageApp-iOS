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

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavigationItem()
        self.setDelegateDataSource()
    }
}

// MARK: - Initialized Method
extension RecipeViewController {
    private func setNavigationItem() {
        self.setNavigationBar(title: "りょうりきろく")
    }
    private func setDelegateDataSource() {
        self.baseView.delegate = self
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
