//
//  AccountSettingViewController.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2022/1/1.
//  Copyright © 2022 shusuke. All rights reserved.
//

import CropViewController
import KAAnalytics
import KSAccountSettingService
import UIKit

class AccountSettingViewController: UIViewController, UIViewControllerNavigatable {
    private var viewModel: AccountSettingViewModel!

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = AccountSettingViewModel()
        viewModel.delegate = self
        setNavigation()

        let baseView = AccountSettingBaseView(state: viewModel.state, delegate: self)
        let _ = addBaseView(baseView: baseView)

        viewModel.loadKikurageUser()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        FirebaseAnalyticsManager.sendScreenViewEvent(.accountSetting)
    }

    // MARK: - Action

    @objc private func close(_ sender: UIBarButtonItem) {
        presentingViewController?.dismiss(animated: true)
    }
}

// MARK: - Initialized

extension AccountSettingViewController {
    private func setNavigation() {
        let closeButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(close(_:)))
        navigationItem.rightBarButtonItems = [closeButtonItem]
        navigationItem.title = R.string.localizable.side_menu_setting_title()
    }
}

// MARK: - SettingBaseView Delegate

extension AccountSettingViewController: AccountSettingBaseViewDelegate {
    func settingBaseViewDidTapUserImageView() {
        // FIXME: 写真アプリから写真を選んで円形にトリミング（CropViewController）してViewModelにあるKikurageUserを更新する
    }

    func settingBaseViewDidTapEditButton() {
        // FIXME: ViewModelにあるkikurageUserを更新する処理を書く
        FirebaseAnalyticsManager.sendTapEvent(.accountSettingButton)
        print("DEBUG: ボタンがタップされました")
    }
}

// MARK: - SettingViewModel Delegate

extension AccountSettingViewController: AccountSettingViewModelDelegate {
    func settingViewModelDidSuccessGetKikurageUser(_ settingViewModel: AccountSettingViewModel) {}

    func settingViewModelDidFailedGetKikurageUser(_ settingViewModel: AccountSettingViewModel, with errorMessage: String) {}
}
