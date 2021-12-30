//
//  LoginViewController.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2021/9/5.
//  Copyright © 2021 shusuke. All rights reserved.
//

import UIKit
import PKHUD

class LoginViewController: UIViewController, UIViewControllerNavigatable {
    private var baseView: LoginBaseView { self.view as! LoginBaseView } // swiftlint:disable:this force_cast
    private var viewModel: LoginViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "ログイン"
        viewModel = LoginViewModel(signUpRepository: SignUpRepository(), loginRepository: LoginRepository(), kikurageStateRepository: KikurageStateRepository(), kikurageUserRepository: KikurageUserRepository())

        setDelegate()
        adjustNavigationBarBackgroundColor()
    }
}

// MARK: - Initialized

extension LoginViewController {
    private func setDelegate() {
        baseView.delegate = self
        baseView.emailTextField.delegate = self
        baseView.passwordTextField.delegate = self
        viewModel.delegate = self
    }
}

// MARK: - LoginBaseView Delegate

extension LoginViewController: LoginBaseViewDelegate {
    func didTappedLoginButton() {
        HUD.show(.progress)
        viewModel.login()
    }
}

// MARK: - UITextField Delegate

extension LoginViewController: UITextFieldDelegate {
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

// MARK: - LoginViewModel Delegate

extension LoginViewController: LoginViewModelDelegate {
    func didSuccessLogin() {
        DispatchQueue.main.async {
            HUD.hide()
            self.transitionHomePage()
        }
    }
    func didFailedLogin(errorMessage: String) {
        DispatchQueue.main.async {
            HUD.hide()
            UIAlertController.showAlert(style: .alert, viewController: self, title: errorMessage, message: errorMessage, okButtonTitle: "OK", cancelButtonTitle: nil) { [weak self] in
                self?.baseView.initTextFields()
                self?.viewModel.initLoginInfo()
            }
        }
    }
    private func transitionHomePage() {
        guard let vc = R.storyboard.homeViewController.instantiateInitialViewController() else { return }
        vc.kikurageUser = viewModel.kikurageUser
        vc.kikurageState = viewModel.kikurageState
        navigationController?.pushViewController(vc, animated: true)
    }
}
