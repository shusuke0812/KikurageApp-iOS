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
    private var viewModel: CultivationViewModel!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = CultivationViewModel(cultivationRepository: CultivationRepository())
        self.setNavigationItem()
        self.setDelegateDataSource()
    }
}
// MARK: - Initialized Method
extension CultivationViewController {
    private func setNavigationItem() {
        self.setNavigationBar(title: "さいばいきろく")
    }
    private func setDelegateDataSource() {
        self.baseView.delegate = self
        self.viewModel.delegate = self
    }
}
// MARK: - CultivationBaseView Delegate Method
extension CultivationViewController: CultivationBaseViewDelegate {
    func didTapPostCultivationPageButton() {
        let s = UIStoryboard(name: "PostCultivationViewController", bundle: nil)
        let vc = s.instantiateInitialViewController() as! PostCultivationViewController
        self.present(vc, animated: true, completion: nil)
    }
}
// MARK: - CultivationViewModel Delegate Method
extension CultivationViewController: CultivationViewModelDelegate {
    func didSuccessGetCultivations() {
        <#code#>
    }
    func didFailedGetCultivations(errorMessage: String) {
        <#code#>
    }
}
