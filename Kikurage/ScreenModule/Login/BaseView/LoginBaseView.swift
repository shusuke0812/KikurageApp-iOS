//
//  LoginBaseView.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2021/9/5.
//  Copyright © 2021 shusuke. All rights reserved.
//

import UIKit

protocol LoginBaseViewDelegate: AnyObject {
    func didTappedLoginButton()
}

class LoginBaseView: UIView {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet private weak var loginButton: UIButton!

    weak var delegate: LoginBaseViewDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        initUI()
    }
    // MARK: - Action
    @IBAction private func didTappedLoginButton(_ sender: Any) {
        delegate?.didTappedLoginButton()
    }
}

// MARK: - Initialized
extension LoginBaseView {
    private func initUI() {
        loginButton.layer.masksToBounds = true
        loginButton.layer.cornerRadius = .buttonCornerRadius
        loginButton.setTitle(R.string.localizable.screen_login_login_btn_name(), for: .normal)

        emailTextField.autocorrectionType = .no
        emailTextField.placeholder = R.string.localizable.screen_login_email_textfield_placeholer()

        passwordTextField.isSecureTextEntry = true
        passwordTextField.placeholder = R.string.localizable.screen_login_password_textfield_placeholer()
    }
    func initTextFields() {
        emailTextField.text = ""
        passwordTextField.text = ""
    }
}
