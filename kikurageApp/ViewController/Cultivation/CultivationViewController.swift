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
    private var baseView: CultivationBaseView { self.view as! CultivationBaseView }
    /// ViewModel
    //private var viewModel:
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavigationItem()
        self.setDelegate()
    }
}
// MARK: - Initialized Method
extension CultivationViewController {
    private func setNavigationItem() {
        self.setNavigationBar(title: "さいばいきろく")
    }
}
// MARK: - CultivationBaseView Delegate Method
extension CultivationViewController: CultivationBaseViewDelegate {
    private func setDelegate() {
        self.baseView.delegate = self
    }
    func didTapPostCultivationPageButton() {
        let s = UIStoryboard(name: "PostCultivationViewController", bundle: nil)
        let vc = s.instantiateInitialViewController() as! PostCultivationViewController
        self.present(vc, animated: true, completion: nil)
    }
}
