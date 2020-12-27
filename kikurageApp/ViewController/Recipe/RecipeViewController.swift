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

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
    }
}

// MARK: - Initialized Method
extension RecipeViewController {
    private func setUI() {
        // ナビゲーションバーの体裁を設定
        self.setNavigationBar(title: "りょうりきろく")
    }
}
