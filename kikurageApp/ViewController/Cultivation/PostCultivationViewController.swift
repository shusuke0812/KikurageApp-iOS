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
    }
}
// MARK: - Dekegate Method
extension PostCultivationViewController {}
