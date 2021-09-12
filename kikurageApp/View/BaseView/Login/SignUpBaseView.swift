//
//  SignUpBaseView.swift
//  kikurageApp
//
//  Created by Shusuke Ota on 2021/9/5.
//  Copyright © 2021 shusuke. All rights reserved.
//

import UIKit

protocol SignUpBaseViewDelegate: AnyObject {
    func didTappedUserRegisterButton()
}

class SignUpBaseView: UIView {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet private weak var userRegisterButton: UIButton!

    weak var delegate: SignUpBaseViewDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        self.initUI()
        self.initTextFieldTag()
    }

    // MARK: - Action
    @IBAction private func didTappedUserRegisterButton(_ sender: Any) {
        self.delegate?.didTappedUserRegisterButton()
    }
}

// MARK: - Initialized
extension SignUpBaseView {
    private func initUI() {
        self.userRegisterButton.layer.masksToBounds = true
        self.userRegisterButton.layer.cornerRadius = 5

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
