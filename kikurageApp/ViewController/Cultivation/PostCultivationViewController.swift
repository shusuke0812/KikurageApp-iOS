//
//  PostCultivationViewController.swift
//  kikurageApp
//
//  Created by Shusuke Ota on 2020/11/14.
//  Copyright © 2020 shusuke. All rights reserved.
//

import UIKit

class PostCultivationViewController: UIViewController {
    /// BaseView
    private var baseView: PostCultivationBaseView { self.view as! PostCultivationBaseView}
    /// ViewModel
    private var viewModel: PostCultivationViewModel!
    /// きくらげユーザーID
    var kikurageUserId: String?
    /// 栽培記録
    var cultivation: KikurageCultivation?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = PostCultivationViewModel(cultivationRepository: CultivationRepository())
        self.setDelegate()
    }
}
// MARK: - Initialized Method
extension PostCultivationViewController {
    private func initUI() {
        
    }
    private func setDelegate() {
        self.baseView.delegate = self
    }
}

// MARK: - Dekegate Method
extension PostCultivationViewController: PostCultivationBaseViewDelegate {
    func didTapPostButton() {
    }
    func didTapCloseButton() {
        self.dismiss(animated: true, completion: nil)
    }
}
