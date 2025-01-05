//
//  SignUpViewController.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2021/9/5.
//  Copyright © 2021 shusuke. All rights reserved.
//

import PKHUD
import RxCocoa
import UIKit
import KSSignUpService
import KDRepository

class SignUpViewController: UIViewController, UIViewControllerNavigatable, SignUpAccessable {
    private let baseView = SignUpBaseView()
    private var viewModel: SignUpViewModel!

    // MARK: - Lifecycle

    override func loadView() {
        view = baseView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = R.string.localizable.screen_signup_title()
        viewModel = SignUpViewModel(loginRepository: LoginRepository())

        setDelegate()
        adjustNavigationBarBackgroundColor()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        FirebaseAnalyticsHelper.sendScreenViewEvent(.signUp)
    }
}

// MARK: - Initialized

extension SignUpViewController {
    private func setDelegate() {
        baseView.delegate = self
        baseView.configTextField(delegate: self)
        viewModel.delegate = self
    }
}

// MARK: - SignUpBaseView Delegate

extension SignUpViewController: SignUpBaseViewDelegate {
    func signUpBaseViewDidTappedRegisterUserButton(_ signUpBaseView: SignUpBaseView) {
        HUD.show(.progress)
        viewModel.registerUser()
    }
}

// MARK: - UITextField Delegate

extension SignUpViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text else {
            return
        }
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
    func signUpViewModelDidSuccessRegisterUser(_ signUpViewModel: SignUpViewModel) {
        DispatchQueue.main.async {
            HUD.hide()
            UIAlertController.showAlert(style: .alert, viewController: self, title: "仮登録完了", message: "入力したメールアドレスに送ったリンクから本登録を行い次へ進んでください", okButtonTitle: "次へ", cancelButtonTitle: nil) {
                self.viewModel.reloadUser { [weak self] result in
                    switch result {
                    case .success:
                        self?.pushToDeviceRegister()
                    case .failure(let error):
                        assertionFailure("\(error)")
                    }
                }
            }
        }
    }

    func signUpViewModelDidFailedRegisterUser(_ signUpViewModel: SignUpViewModel, with errorMessage: String) {
        DispatchQueue.main.async {
            HUD.hide()
            UIAlertController.showAlert(style: .alert, viewController: self, title: errorMessage, message: errorMessage, okButtonTitle: "OK", cancelButtonTitle: nil) {
                signUpViewModel.initUserInfo()
                self.baseView.initTextFields()
            }
        }
    }
}
