//
//  SignUpBaseView.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2021/9/5.
//  Copyright © 2021 shusuke. All rights reserved.
//

import KikurageUI
import UIKit

protocol SignUpBaseViewDelegate: AnyObject {
    func signUpBaseViewDidTappedRegisterUserButton(_ signUpBaseView: SignUpBaseView)
}

class SignUpBaseView: UIView {
    private(set) var emailTextField: KUITextField!
    private(set) var passwordTextField: KUIPasswordField!
    private var userRegisterButton: KUIButton!

    weak var delegate: SignUpBaseViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupComponent()
        setupButtonAction()
    }

    required init?(coder: NSCoder) {
        nil
    }

    private func setupComponent() {
        backgroundColor = .systemGroupedBackground

        emailTextField = KUITextField(props: KUITextFieldProps(
            placeHolder: R.string.localizable.screen_signup_email_textfield_placeholer()
        ))

        passwordTextField = KUIPasswordField(props: KUITextFieldProps(
            placeHolder: R.string.localizable.screen_signup_password_textfield_placeholer()
        ))

        userRegisterButton = KUIButton(props: KUIButtonProps(
            type: .primary,
            title: R.string.localizable.screen_signup_signup_btn_name()
        ))

        addSubview(emailTextField)
        addSubview(passwordTextField)
        addSubview(userRegisterButton)

        NSLayoutConstraint.activate([
            emailTextField.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 40),
            emailTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
            emailTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),

            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 25),
            passwordTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
            passwordTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),

            userRegisterButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 35),
            userRegisterButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
            userRegisterButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),
            userRegisterButton.heightAnchor.constraint(equalToConstant: 45)
        ])
    }

    // MARK: - Action

    private func setupButtonAction() {
        userRegisterButton.onTap = { [weak self] in
            guard let self else {
                return
            }
            self.delegate?.signUpBaseViewDidTappedRegisterUserButton(self)
        }
    }
}

// MARK: - Config

extension SignUpBaseView {
    func configTextField(delegate: UITextFieldDelegate) {
        emailTextField.delegate = delegate
        passwordTextField.delegate = delegate
    }

    func initTextFields() {
        emailTextField.text = ""
        passwordTextField.text = ""
    }
}
