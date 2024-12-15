//
//  AccountSettingViewController.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2022/1/1.
//  Copyright © 2022 shusuke. All rights reserved.
//

import CropViewController
import KikurageFeature

class AccountSettingViewController: UIViewController {
    private var baseView: AccountSettingBaseView = .init()
    private var viewModel: AccountSettingViewModel!

    // MARK: - Lifecycle

    override func loadView() {
        view = baseView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = AccountSettingViewModel(kikurageUserRepository: KikurageUserRepository())
        setDelegateDataSource()
        setNavigation()

        if let userID = LoginHelper.shared.kikurageUserID {
            viewModel.loadKikurageUser(uid: userID)
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        FirebaseAnalyticsHelper.sendScreenViewEvent(.accountSetting)
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
        FirebaseAnalyticsHelper.sendTapEvent(.accountSettingButton)
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
