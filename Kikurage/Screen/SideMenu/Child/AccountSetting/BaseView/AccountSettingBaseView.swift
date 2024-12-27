//
//  AccountSettingBaseView.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2022/1/1.
//  Copyright © 2022 shusuke. All rights reserved.
//

import KikurageUI
import UIKit

protocol AccountSettingBaseViewDelegate: AnyObject {
    func settingBaseViewDidTappedEditButton(_ settingBaseView: AccountSettingBaseView)
    func settingBaseViewDidTappedUserImageView(_ settingBaseView: AccountSettingBaseView)
}

class AccountSettingBaseView: UIView {
    private var userImageView: KUICircleImageView!
    private var kikurageNameTextField: KUIMaterialTextField!
    private var editButton: KUIButton!

    private let userImageViewWidth: CGFloat = 160

    weak var delegate: AccountSettingBaseViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupComponent()
        setupActions()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupComponent() {
        backgroundColor = .systemGroupedBackground

        userImageView = KUICircleImageView(props: KUICircleImageViewProps(
            image: R.image.hakase(),
            width: userImageViewWidth
        ))
        userImageView.isUserInteractionEnabled = true
        userImageView.translatesAutoresizingMaskIntoConstraints = false

        kikurageNameTextField = KUIMaterialTextField(props: KUIMaterialTextFieldProps(
            maxTextCount: 30,
            alignment: .center,
            fontSize: 20
        ))
        kikurageNameTextField.translatesAutoresizingMaskIntoConstraints = false

        editButton = KUIButton(props: KUIButtonProps(
            variant: .primary,
            title: R.string.localizable.side_menu_setting_edit_btn_title()
        ))
        editButton.translatesAutoresizingMaskIntoConstraints = false

        addSubview(userImageView)
        addSubview(kikurageNameTextField)
        addSubview(editButton)

        NSLayoutConstraint.activate([
            userImageView.widthAnchor.constraint(equalToConstant: userImageViewWidth),
            userImageView.heightAnchor.constraint(equalToConstant: userImageViewWidth),
            userImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            userImageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 40),

            kikurageNameTextField.topAnchor.constraint(equalTo: userImageView.bottomAnchor, constant: 40),
            kikurageNameTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            kikurageNameTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),

            editButton.heightAnchor.constraint(equalToConstant: 45),
            editButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            editButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            editButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -30)
        ])
    }

    private func setupActions() {
        let userImageViewTapGestureRecoizer = UITapGestureRecognizer(
            target: self,
            action: #selector(onTapUserImageView(_:))
        )
        userImageView.addGestureRecognizer(userImageViewTapGestureRecoizer)

        editButton.addAction(.init { [weak self] _ in
            guard let self else {
                return
            }
            self.delegate?.settingBaseViewDidTappedEditButton(self)
        }, for: .touchUpInside)
    }

    @objc private func onTapUserImageView(_ sender: UIGestureRecognizer) {
        delegate?.settingBaseViewDidTappedUserImageView(self)
    }
}

// MARK: - Setting UI

extension AccountSettingBaseView {
    func setKikurageName(name: String?) {
        if let name = name {
            kikurageNameTextField.setupText(name)
        }
    }
}
