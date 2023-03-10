//
//  SettingViewController.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2022/1/1.
//  Copyright © 2022 shusuke. All rights reserved.
//

import CropViewController
import UIKit

class SettingViewController: UIViewController {
    private var baseView: SettingBaseView { view as! SettingBaseView } // sswiftlint:disable:this force_cast
    private var viewModel: SettingViewModel!

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = SettingViewModel(kikurageUserRepository: KikurageUserRepository())
        setDelegateDataSource()
        setNavigation()

        if let userID = LoginHelper.shared.kikurageUserID {
            viewModel.loadKikurageUser(uid: userID)
        }
    }

    // MARK: - Action

    @objc private func close(_ sender: UIBarButtonItem) {
        presentingViewController?.dismiss(animated: true)
    }
}

// MARK: - Initialized

extension SettingViewController {
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

extension SettingViewController: SettingBaseViewDelegate {
    func settingBaseViewDidTappedUserImageView(_ settingBaseView: SettingBaseView) {
        // FIXME: 写真アプリから写真を選んで円形にトリミング（CropViewController）してViewModelにあるKikurageUserを更新する
    }

    func settingBaseViewDidTappedEditButton(_ settingBaseView: SettingBaseView) {
        // FIXME: ViewModelにあるkikurageUserを更新する処理を書く
    }
}

// MARK: - SettingViewModel Delegate

extension SettingViewController: SettingViewModelDelegate {
    func settingViewModelDidSuccessGetKikurageUser(_ settingViewModel: SettingViewModel) {
        DispatchQueue.main.async {
            self.baseView.setKikurageName(name: settingViewModel.kikurageUser?.kikurageName)
        }
    }

    func settingViewModelDidFailedGetKikurageUser(_ settingViewModel: SettingViewModel, with errorMessage: String) {
        DispatchQueue.main.async {
            self.baseView.setKikurageName(name: nil)
        }
    }
}
