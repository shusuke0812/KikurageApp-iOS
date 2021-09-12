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
        self.initUI()
        self.initTextFieldTag()
    }
    // MARK: - Action
    @IBAction private func didTappedLoginButton(_ sender: Any) {
        self.delegate?.didTappedLoginButton()
    }
}

// MARK: - Initialized
extension LoginBaseView {
    private func initUI() {
        self.loginButton.layer.masksToBounds = true
        self.loginButton.layer.cornerRadius = 5

        self.emailTextField.autocorrectionType = .no
        self.passwordTextField.isSecureTextEntry = true
    }
    private func initTextFieldTag() {
        self.emailTextField.tag = Constants.TextFieldTag.email
        self.passwordTextField.tag = Constants.TextFieldTag.password
    }
    func initTextFields() {
        self.emailTextField.text = ""
        self.passwordTextField.text = ""
    }
}
