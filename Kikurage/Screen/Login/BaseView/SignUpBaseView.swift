//
//  SignUpBaseView.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2021/9/5.
//  Copyright © 2021 shusuke. All rights reserved.
//

import UIKit

protocol SignUpBaseViewDelegate: AnyObject {
    func signUpBaseViewDidTappedRegisterUserButton(_ signUpBaseView: SignUpBaseView)
}

class SignUpBaseView: UIView {
    @IBOutlet private(set) weak var emailTextField: UITextField!
    @IBOutlet private(set) weak var passwordTextField: UITextField!
    @IBOutlet private weak var userRegisterButton: UIButton!

    weak var delegate: SignUpBaseViewDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        initUI()
    }

    // MARK: - Action

    @IBAction private func registerUser(_ sender: Any) {
        delegate?.signUpBaseViewDidTappedRegisterUserButton(self)
    }
}

// MARK: - Initialized

extension SignUpBaseView {
    private func initUI() {
        backgroundColor = .systemGroupedBackground

        userRegisterButton.layer.masksToBounds = true
        userRegisterButton.layer.cornerRadius = .buttonCornerRadius
        userRegisterButton.setTitle(R.string.localizable.screen_signup_signup_btn_name(), for: .normal)

        emailTextField.autocorrectionType = .no
        emailTextField.placeholder = R.string.localizable.screen_signup_email_textfield_placeholer()

        passwordTextField.isSecureTextEntry = true
        passwordTextField.placeholder = R.string.localizable.screen_signup_password_textfield_placeholer()
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
