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
        initUI()
        initTextFieldTag()
    }

    // MARK: - Action
    @IBAction private func didTappedUserRegisterButton(_ sender: Any) {
        delegate?.didTappedUserRegisterButton()
    }
}

// MARK: - Initialized
extension SignUpBaseView {
    private func initUI() {
        userRegisterButton.layer.masksToBounds = true
        userRegisterButton.layer.cornerRadius = 5

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
