//
//  SignUpBaseView.swift
//  kikurageApp
//
//  Created by Shusuke Ota on 2021/9/5.
//  Copyright © 2021 shusuke. All rights reserved.
//

import UIKit

class SignUpBaseView: UIView {
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var userRegisterButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.initUI()
    }

    // MARK: - Action
    @IBAction private func didTappedUserRegisterButton(_ sender: Any) {
    }
}

// MARK: - Initialized
extension SignUpBaseView {
    private func initUI() {
        self.userRegisterButton.layer.masksToBounds = true
        self.userRegisterButton.layer.cornerRadius = 5

        self.passwordTextField.isSecureTextEntry = true
    }
}
