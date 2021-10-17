//
//  LoginBaseView.swift
//  kikurageApp
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
        initTextFieldTag()
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
        loginButton.layer.cornerRadius = 5

        emailTextField.autocorrectionType = .no
        passwordTextField.isSecureTextEntry = true
    }
    private func initTextFieldTag() {
        emailTextField.tag = Constants.TextFieldTag.email
        passwordTextField.tag = Constants.TextFieldTag.password
    }
    func initTextFields() {
        emailTextField.text = ""
        passwordTextField.text = ""
    }
}
