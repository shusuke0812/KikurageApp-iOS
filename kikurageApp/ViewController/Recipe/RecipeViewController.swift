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

    // MARK: - Action Method
    @IBAction func cookPadButton(_ sender: Any) {
        guard let url = URL(string: "https://cookpad.com/search/%E3%81%8D%E3%81%8F%E3%82%89%E3%81%92") else { return }
        let safariController = SFSafariViewController(url: url)
        present(safariController, animated: true, completion: nil)
    }
}

// MARK: - Initialized Method
extension RecipeViewController {
    private func setUI() {
        // ナビゲーションバーの体裁を設定
        self.setNavigationBar(title: "りょうりきろく")
    }
}
