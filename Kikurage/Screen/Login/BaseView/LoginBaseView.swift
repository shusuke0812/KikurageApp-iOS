//
//  LoginBaseView.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2021/9/5.
//  Copyright © 2021 shusuke. All rights reserved.
//

import UIKit

protocol LoginBaseViewDelegate: AnyObject {
    func loginBaseViewDidTappedLoginButton(_ loginBaseView: LoginBaseView)
}

class LoginBaseView: UIView {
    @IBOutlet private(set) weak var emailTextField: UITextField!
    @IBOutlet private(set) weak var passwordTextField: UITextField!
    @IBOutlet private weak var loginButton: UIButton!

    weak var delegate: LoginBaseViewDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        initUI()
    }

    // MARK: - Action

    @IBAction private func login(_ sender: Any) {
        delegate?.loginBaseViewDidTappedLoginButton(self)
    }
}

// MARK: - Initialized

extension LoginBaseView {
    private func initUI() {
        backgroundColor = .systemGroupedBackground

        loginButton.layer.masksToBounds = true
        loginButton.layer.cornerRadius = .buttonCornerRadius
        loginButton.setTitle(R.string.localizable.screen_login_login_btn_name(), for: .normal)
        loginButton.accessibilityIdentifier = AccessibilityIdentifierManager.loginLoginButton()

        emailTextField.autocorrectionType = .no
        emailTextField.placeholder = R.string.localizable.screen_login_email_textfield_placeholer()
        emailTextField.accessibilityIdentifier = AccessibilityIdentifierManager.loginEmailTextField()

        passwordTextField.isSecureTextEntry = true
        passwordTextField.placeholder = R.string.localizable.screen_login_password_textfield_placeholer()
        passwordTextField.accessibilityIdentifier = AccessibilityIdentifierManager.loginPasswordTextField()
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
