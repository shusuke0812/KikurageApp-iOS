//
//  SettingViewController.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2022/1/1.
//  Copyright © 2022 shusuke. All rights reserved.
//

import UIKit

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
    }
    func didTappedEditButton() {
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
    }
}
