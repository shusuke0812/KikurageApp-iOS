//
//  CultivationDetailViewController.swift
//  kikurageApp
//
//  Created by Shusuke Ota on 2020/12/19.
//  Copyright © 2020 shusuke. All rights reserved.
//

import UIKit

class CultivationDetailViewController: UIViewController {
    
    /// BaseView
    private var baseView: CultivationDetailBaseView { self.view as! CultivationDetailBaseView }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavigationItem()
    }
}
// MARK: - Private Method
extension CultivationDetailViewController {
    private func setNavigationItem() {
        self.setNavigationBar(title: "さいばいきろく詳細")
    }
}
