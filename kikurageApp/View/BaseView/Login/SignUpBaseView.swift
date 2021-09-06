//
//  SignUpBaseView.swift
//  kikurageApp
//
//  Created by Shusuke Ota on 2021/9/5.
//  Copyright © 2021 shusuke. All rights reserved.
//

import UIKit

protocol SignUpBaseViewDelegate: AnyObject {
    func didTappedUserRegisterButton(registerInfo: (email :String, password: String))
}

class SignUpBaseView: UIView {
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var userRegisterButton: UIButton!
    
    private var email: String = ""
    private var password: String = ""
    
    weak var delegate: SignUpBaseViewDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        self.initUI()
    }

    // MARK: - Action
    @IBAction private func didTappedUserRegisterButton(_ sender: Any) {
        self.delegate?.didTappedUserRegisterButton(registerInfo: (email, password))
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
