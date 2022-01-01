//
//  SettingViewController.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2022/1/1.
//  Copyright © 2022 shusuke. All rights reserved.
//

import UIKit
import CropViewController

class SettingViewController: UIViewController {
    private var baseView: SettingBaseView { self.view as! SettingBaseView } // sswiftlint:disable:this force_cast
    private var viewModel: SettingViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = SettingViewModel(kikurageUserRepository: KikurageUserRepository())
        setDelegateDataSource()

        if let userId = LoginHelper.shared.kikurageUserId {
            viewModel.loadKikurageUser(uid: userId)
        }
    }
}

// MARK: - Initialized

extension SettingViewController {
    private func setDelegateDataSource() {
        baseView.delegate = self
        viewModel.delegate = self
    }
}

// MARK: - SettingBaseView Delegate

extension SettingViewController: SettingBaseViewDelegate {
    func didTappedUserImageView() {
        // FIXME: 写真アプリから写真を選んで円形にトリミング（CropViewController）してViewModelにあるKikurageUserを更新する
    }
    func didTappedEditButton() {
        // FIXME: ViewModelにあるkikurageUserを更新する処理を書く
    }
    func didTappedCloseButton() {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - SettingViewModel Delegate

extension SettingViewController: SettingViewModelDelegate {
    func didSuccessGetKikurageUser() {
        DispatchQueue.main.async {
            self.baseView.setKikurageName(name: self.viewModel.kikurageUser?.kikurageName)
        }
    }
    func didFailedGetKikurageUser(errorMessage: String) {
        DispatchQueue.main.async {
            self.baseView.setKikurageName(name: nil)
        }
    }
}
