//
//  SignUpViewController.swift
//  kikurageApp
//
//  Created by Shusuke Ota on 2021/9/5.
//  Copyright © 2021 shusuke. All rights reserved.
//

import UIKit
import PKHUD

class SignUpViewController: UIViewController {
    /// BaseView
    private var baseView: SignUpBaseView { self.view as! SignUpBaseView } // swiftlint:disable:this force_cast
    /// ViewModel
    private var viewModel: SignUpViewModel!

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "ユーザー登録"
        self.viewModel = SignUpViewModel(signUpRepository: SignUpRepository())

        self.setDelegate()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
}

// MARK: - Initialized
extension SignUpViewController {
    private func setDelegate() {
        self.baseView.delegate = self
        self.baseView.emailTextField.delegate = self
        self.baseView.passwordTextField.delegate = self
        self.viewModel.delegate = self
    }
}

// MARK: - SignUpBaseView Delegate
extension SignUpViewController: SignUpBaseViewDelegate {
    func didTappedUserRegisterButton() {
        HUD.show(.progress)
        self.viewModel.registerUser()
    }
}

// MARK: - UITextField Delegate
extension SignUpViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text else { return }
        switch textField.tag {
        case Constants.TextFieldTag.email:
            self.viewModel.email = text
        case Constants.TextFieldTag.password:
            self.viewModel.password = text
        default:
            break
        }
    }
}

// MARK: - SignUpViewModel Delegate
extension SignUpViewController: SignUpViewModelDelegate {
    func didSuccessRegisterUser() {
        DispatchQueue.main.async {
            HUD.hide()
            guard let vc = R.storyboard.deviceRegisterViewController.instantiateInitialViewController() else { return }
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    func didFailedRegisterUser(errorMessage: String) {
        DispatchQueue.main.async {
            HUD.hide()
            UIAlertController.showAlert(style: .alert, viewController: self, title: "エラー", message: errorMessage, okButtonTitle: "OK", cancelButtonTitle: nil) {
                self.viewModel.initUserInfo()
                self.baseView.initTextFields()
            }
        }
    }
}