//
//  LoginViewController.swift
//  kikurageApp
//
//  Created by Shusuke Ota on 2021/9/5.
//  Copyright © 2021 shusuke. All rights reserved.
//

import UIKit
import PKHUD

class LoginViewController: UIViewController {
    /// BaseView
    private var baseView: LoginBaseView { self.view as! LoginBaseView } // swiftlint:disable:this force_cast
    /// ViewModel
    private var viewModel: LoginViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "ログイン"
        self.viewModel = LoginViewModel(loginRepository: LoginRepository(), kikurageStateRepository: KikurageStateRepository(), kikurageUserRepository: KikurageUserRepository())

        self.setDelegate()
    }
}

// MARK: - Initialized
extension LoginViewController {
    private func setDelegate() {
        self.baseView.delegate = self
        self.baseView.emailTextField.delegate = self
        self.baseView.passwordTextField.delegate = self
        self.viewModel.delegate = self
    }
}

// MARK: - LoginBaseView Delegate
extension LoginViewController: LoginBaseViewDelegate {
    func didTappedLoginButton() {
        HUD.show(.progress)
        self.viewModel.login()
    }
}

// MARK: - UITextField Delegate
extension LoginViewController: UITextFieldDelegate {
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
            UIAlertController.showAlert(style: .alert, viewController: self, title: "エラー", message: errorMessage, okButtonTitle: "OK", cancelButtonTitle: nil) { [weak self] in
                self?.baseView.initTextFields()
                self?.viewModel.initLoginInfo()
            }
        }
    }
    private func transitionHomePage() {
        guard let vc = R.storyboard.mainViewController.instantiateInitialViewController() else { return }
        let mainVC = vc.topViewController as! MainViewController // swiftlint:disable:this force_cast
        mainVC.kikurageUser = self.viewModel.kikurageUser
        mainVC.kikurageState = self.viewModel.kikurageState
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
}
