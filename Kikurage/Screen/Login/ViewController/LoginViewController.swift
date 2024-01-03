//
//  LoginViewController.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2021/9/5.
//  Copyright © 2021 shusuke. All rights reserved.
//

import PKHUD
import UIKit

class LoginViewController: UIViewController, UIViewControllerNavigatable, TopAccessable {
    private var baseView: LoginBaseView { view as! LoginBaseView } // swiftlint:disable:this force_cast
    private var viewModel: LoginViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = R.string.localizable.screen_login_title()
        viewModel = LoginViewModel(signUpRepository: SignUpRepository(), loginRepository: LoginRepository())

        setDelegate()
        adjustNavigationBarBackgroundColor()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        FirebaseAnalyticsHelper.sendScreenViewEvent(.login)
    }
}

// MARK: - Initialized

extension LoginViewController {
    private func setDelegate() {
        baseView.delegate = self
        viewModel.delegate = self
        baseView.confgTextField(delegate: self)
    }
}

// MARK: - LoginBaseView Delegate

extension LoginViewController: LoginBaseViewDelegate {
    func loginBaseViewDidTappedLoginButton(_ loginBaseView: LoginBaseView) {
        HUD.show(.progress)
        viewModel.login()
    }
}

// MARK: - UITextField Delegate

extension LoginViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text else {
            return
        }
        switch textField {
        case baseView.emailTextField:
            viewModel.setEmail(text)
        case baseView.passwordTextField:
            viewModel.setPassword(text)
        default:
            break
        }
    }
}

// MARK: - LoginViewModel Delegate

extension LoginViewController: LoginViewModelDelegate {
    func loginViewModelDidSuccessLogin(_ loginViewModel: LoginViewModel?, user: KikurageUser, state: KikurageState) {
        DispatchQueue.main.async {
            HUD.hide()
            self.pushToHome(kikurageState: state, kikurageUser: user)
        }
    }

    func loginViewModelDidFailedLogin(_ loginViewModel: LoginViewModel?, with errorMessage: String) {
        DispatchQueue.main.async {
            HUD.hide()
            UIAlertController.showAlert(style: .alert, viewController: self, title: errorMessage, message: errorMessage, okButtonTitle: "OK", cancelButtonTitle: nil) { [weak self] in
                self?.baseView.initTextFields()
                loginViewModel?.resetLoginInfo()
            }
        }
    }
}
