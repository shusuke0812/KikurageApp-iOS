//
//  saibaiViewController.swift
//  kikurageApp
//
//  Created by Shusuke Ota on 2019/03/02.
//  Copyright © 2019 shusuke. All rights reserved.
//

import UIKit

class CultivationViewController: UIViewController {
    
    /// BaseView
    /// ViewModel
    //private var viewModel:
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
    }
}
// MARK: - Initialized Method
extension CultivationViewController {
    private func setUI() {
        // ナビゲーションバーの体裁を設定
        self.setNavigationBar(title: "さいばいきろく")
    }
}
