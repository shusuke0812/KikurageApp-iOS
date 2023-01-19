//
//  AccountSettingBaseView.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2022/1/1.
//  Copyright © 2022 shusuke. All rights reserved.
//

import UIKit

protocol AccountSettingBaseViewDelegate: AnyObject {
    func settingBaseViewDidTappedEditButton(_ settingBaseView: AccountSettingBaseView)
    func settingBaseViewDidTappedUserImageView(_ settingBaseView: AccountSettingBaseView)
}

class AccountSettingBaseView: UIView {
    @IBOutlet private weak var userImageView: UIImageView!
    @IBOutlet private weak var kikurageNameTextField: UITextField!
    @IBOutlet private weak var editButton: UIButton!

    weak var delegate: AccountSettingBaseViewDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        initUI()
    }

    // MARK: - Action

    @IBAction private func edit(_ sender: Any) {
        delegate?.settingBaseViewDidTappedEditButton(self)
    }
    @IBAction private func editUserImage(_ sender: Any) {
        delegate?.settingBaseViewDidTappedUserImageView(self)
    }
}

// MARK: - Initialized

extension AccountSettingBaseView {
    private func initUI() {
        backgroundColor = .systemGroupedBackground

        userImageView.image = R.image.hakase()
        userImageView.clipsToBounds = true
        userImageView.layer.cornerRadius = userImageView.frame.width / 2
        userImageView.layer.borderWidth = 0.5
        userImageView.layer.borderColor = UIColor.gray.cgColor

        editButton.setTitle(R.string.localizable.side_menu_setting_edit_btn_title(), for: .normal)
        editButton.setTitleColor(.white, for: .normal)
        editButton.clipsToBounds = true
        editButton.layer.cornerRadius = .buttonCornerRadius
        editButton.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .bold)
    }
}

// MARK: - Setting UI

extension AccountSettingBaseView {
    func setKikurageName(name: String?) {
        if let name = name {
            kikurageNameTextField.text = name
            kikurageNameTextField.isEnabled = true
        } else {
            kikurageNameTextField.placeholder = R.string.localizable.side_menu_setting_kikurage_name_error()
            kikurageNameTextField.isEnabled = false
        }
    }
}
