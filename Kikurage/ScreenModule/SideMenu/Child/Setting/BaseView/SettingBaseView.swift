//
//  SettingBaseView.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2022/1/1.
//  Copyright © 2022 shusuke. All rights reserved.
//

import UIKit

protocol SettingBaseViewDelegate: AnyObject {
    func didTappedEditButton()
    func didTappedUserImageView()
    func didTappedCloseButton()
}

class SettingBaseView: UIView {
    @IBOutlet private weak var navigationItem: UINavigationItem!
    @IBOutlet private weak var userImageView: UIImageView!
    @IBOutlet private weak var kikurageNameTextField: UITextField!
    @IBOutlet private weak var editButton: UIButton!

    weak var delegate: SettingBaseViewDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        initUI()
    }

    // MARK: - Action

    @IBAction private func didTappedEditButton(_ sender: Any) {
        delegate?.didTappedEditButton()
    }
    @IBAction private func didTappedUserImageView(_ sender: Any) {
        delegate?.didTappedUserImageView()
    }
    @IBAction private func didTappedCloseButton(_ sender: Any) {
        delegate?.didTappedCloseButton()
    }
}

// MARK: - Initialized

extension SettingBaseView {
    private func initUI() {
        navigationItem.title = R.string.localizable.side_menu_setting_title()
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

extension SettingBaseView {
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
