//
//  SignUpViewController.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2021/9/5.
//  Copyright © 2021 shusuke. All rights reserved.
//

import UIKit
import PKHUD

class SignUpViewController: UIViewController, UIViewControllerNavigatable {
    private var baseView: SignUpBaseView { self.view as! SignUpBaseView } // swiftlint:disable:this force_cast
    private var viewModel: SignUpViewModel!

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "ユーザー登録"
        viewModel = SignUpViewModel(signUpRepository: SignUpRepository())

        setDelegate()
        adjustNavigationBarBackgroundColor()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}

// MARK: - Initialized
extension SignUpViewController {
    private func setDelegate() {
        baseView.delegate = self
        baseView.emailTextField.delegate = self
        baseView.passwordTextField.delegate = self
        viewModel.delegate = self
    }
}

// MARK: - SignUpBaseView Delegate
extension SignUpViewController: SignUpBaseViewDelegate {
    func didTappedUserRegisterButton() {
        HUD.show(.progress)
        viewModel.registerUser()
    }
}

// MARK: - UITextField Delegate
extension SignUpViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text else { return }
        switch textField {
        case baseView.emailTextField:
            viewModel.email = text
        case baseView.passwordTextField:
            viewModel.password = text
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
            UIAlertController.showAlert(style: .alert, viewController: self, title: "仮登録完了", message: "入力したメールアドレスに送ったリンクから本登録を行い次へ進んでください", okButtonTitle: "次へ", cancelButtonTitle: nil) {
                LoginHelper.shared.userReload { [weak self] in
                    self?.transitionDeviceRegisterPage()
                    LoginHelper.shared.userListenerDetach()
                }
            }
        }
    }
    func didFailedRegisterUser(errorMessage: String) {
        DispatchQueue.main.async {
            HUD.hide()
            UIAlertController.showAlert(style: .alert, viewController: self, title: errorMessage, message: errorMessage, okButtonTitle: "OK", cancelButtonTitle: nil) {
                self.viewModel.initUserInfo()
                self.baseView.initTextFields()
            }
        }
    }
    private func transitionDeviceRegisterPage() {
        guard let vc = R.storyboard.deviceRegisterViewController.instantiateInitialViewController() else { return }
        navigationController?.pushViewController(vc, animated: true)
    }
}
