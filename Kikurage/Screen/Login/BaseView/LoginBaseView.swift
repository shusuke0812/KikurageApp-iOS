//
//  LoginBaseView.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2021/9/5.
//  Copyright © 2021 shusuke. All rights reserved.
//

import KikurageUI
import UIKit

protocol LoginBaseViewDelegate: AnyObject {
    func loginBaseViewDidTappedLoginButton(_ loginBaseView: LoginBaseView)
}

class LoginBaseView: UIView {
    private(set) var emailTextField: KUITextField!
    private(set) var passwordTextField: KUIPasswordField!
    private var loginButton: KUIButton!

    weak var delegate: LoginBaseViewDelegate?

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
            placeHolder: R.string.localizable.screen_login_email_textfield_placeholer(),
            accessibilityIdentifier: AccessibilityIdentifierManager.loginEmailTextField()
        ))

        passwordTextField = KUIPasswordField(props: KUITextFieldProps(
            placeHolder: R.string.localizable.screen_login_password_textfield_placeholer(),
            accessibilityIdentifier: AccessibilityIdentifierManager.loginPasswordTextField()
        ))

        loginButton = KUIButton(props: KUIButtonProps(
            variant: .primary,
            title: R.string.localizable.screen_login_login_btn_name(),
            accessibilityIdentifier: AccessibilityIdentifierManager.loginLoginButton()
        ))

        addSubview(emailTextField)
        addSubview(passwordTextField)
        addSubview(loginButton)

        NSLayoutConstraint.activate([
            emailTextField.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 40),
            emailTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
            emailTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),

            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 25),
            passwordTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
            passwordTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),

            loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 30),
            loginButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
            loginButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),
            loginButton.heightAnchor.constraint(equalToConstant: 45)
        ])
    }

    // MARK: - Action

    private func setupButtonAction() {
        loginButton.onTap = { [weak self] in
            guard let self else {
                return
            }
            self.delegate?.loginBaseViewDidTappedLoginButton(self)
        }
    }
}

// MARK: - Config

extension LoginBaseView {
    func confgTextField(delegate: UITextFieldDelegate) {
        emailTextField.delegate = delegate
        passwordTextField.delegate = delegate
    }

    func initTextFields() {
        emailTextField.text = ""
        passwordTextField.text = ""
    }
}
