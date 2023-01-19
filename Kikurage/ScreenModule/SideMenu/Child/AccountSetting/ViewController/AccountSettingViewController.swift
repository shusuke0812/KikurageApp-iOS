//
//  SettingViewController.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2022/1/1.
//  Copyright © 2022 shusuke. All rights reserved.
//

import UIKit
import CropViewController
import KikurageFeature

class AccountSettingViewController: UIViewController {
    private var baseView: AccountSettingBaseView { self.view as! AccountSettingBaseView } // sswiftlint:disable:this force_cast
    private var viewModel: AccountSettingViewModel!

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = AccountSettingViewModel(kikurageUserRepository: KikurageUserRepository())
        setDelegateDataSource()
        setNavigation()

        if let userId = LoginHelper.shared.kikurageUserId {
            viewModel.loadKikurageUser(uid: userId)
        }
    }

    // MARK: - Action

    @objc private func close(_ sender: UIBarButtonItem) {
        presentingViewController?.dismiss(animated: true)
    }
}

// MARK: - Initialized

extension AccountSettingViewController {
    private func setDelegateDataSource() {
        baseView.delegate = self
        viewModel.delegate = self
    }
    private func setNavigation() {
        let closeButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(close(_:)))
        navigationItem.rightBarButtonItems = [closeButtonItem]
        navigationItem.title = R.string.localizable.side_menu_setting_title()
    }
}

// MARK: - SettingBaseView Delegate

extension AccountSettingViewController: AccountSettingBaseViewDelegate {
    func settingBaseViewDidTappedUserImageView(_ settingBaseView: AccountSettingBaseView) {
        // FIXME: 写真アプリから写真を選んで円形にトリミング（CropViewController）してViewModelにあるKikurageUserを更新する
    }
    func settingBaseViewDidTappedEditButton(_ settingBaseView: AccountSettingBaseView) {
        // FIXME: ViewModelにあるkikurageUserを更新する処理を書く
        print("DEBUG: ボタンがタップされました")
    }
}

// MARK: - SettingViewModel Delegate

extension AccountSettingViewController: AccountSettingViewModelDelegate {
    func settingViewModelDidSuccessGetKikurageUser(_ settingViewModel: AccountSettingViewModel) {
        DispatchQueue.main.async {
            self.baseView.setKikurageName(name: settingViewModel.kikurageUser?.kikurageName)
        }
    }
    func settingViewModelDidFailedGetKikurageUser(_ settingViewModel: AccountSettingViewModel, with errorMessage: String) {
        DispatchQueue.main.async {
            self.baseView.setKikurageName(name: nil)
        }
    }
}
