//
//  loginViewController.swift
//  kikurageApp
//
//  Created by Shusuke Ota on 2019/03/22.
//  Copyright © 2019 shusuke. All rights reserved.
//

import UIKit
import PKHUD

class LoginViewController: UIViewController {
    
    /// BaseView
    private var baseView: LoginBaseView { self.view as! LoginBaseView }
    /// ViewModel
    private var viewModel: LoginViewModel!
    /// Dateヘルパー
    private let dateHelper: DateHelper = DateHelper()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = LoginViewModel(kikurageStateRepository: KikurageStateRepository(),
                                        kikurageUserRepository: KikurageUserRepository())
        self.setDelegateDataSource()
    }
}
// MARK: - Initialized Method
extension LoginViewController {
    private func setDelegateDataSource() {
        self.baseView.delegate = self
        self.baseView.productKeyTextField.delegate = self
        self.baseView.kikurageNameTextField.delegate = self
        self.baseView.cultivationStartDateTextField.delegate = self
        self.viewModel.delegate = self
    }
}
// MARK: - UITextField Delegate Method
extension LoginViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text else { return }
        switch textField.tag {
        case Constants.TextFieldTag.productKey:
            self.baseView.productKeyTextField.text = text
            self.viewModel.kikurageUser?.productKey = text
            self.viewModel.setStateReference(productKey: text)
        case Constants.TextFieldTag.kikurageName:
            self.baseView.kikurageNameTextField.text = text
            self.viewModel.kikurageUser?.kikurageName = text
        case Constants.TextFieldTag.cultivationStartDate:
            self.setCultivationStartDateTextFieldData()
        default:
            break
        }
    }
    private func setCultivationStartDateTextFieldData() {
        let date: Date = self.baseView.datePicker.date
        let dataString: String = self.dateHelper.formatToString(date: date)
        self.baseView.cultivationStartDateTextField.text = dataString
        self.viewModel.kikurageUser?.cultivationStartDate = date
    }
}
// MARK: - LoginBaseView Delegate Method
extension LoginViewController: LoginBaseViewDelegate {
    func didTapLoginButton() {
        let validate = self.textFieldValidation()
        if validate {
            // HUD表示（始）
            HUD.show(.progress)
            // きくらげの状態を取得する
            self.viewModel.loadKikurageState()
        } else {
            UIAlertController.showAlert(style: .alert, viewController: self, title: "入力されていない\n項目があります", message: nil, okButtonTitle: "OK", cancelButtonTitle: nil, completionOk: nil)
        }
    }
    func didTapTermsButton() {
        self.transitionSafariViewController(urlString: Constants.WebUrl.terms)
    }
    func didTapPrivacyPolicyButton() {
        self.transitionSafariViewController(urlString: Constants.WebUrl.privacyPolicy)
    }
    func textFieldValidation() -> Bool {
        guard let productKey = self.baseView.productKeyTextField.text,
              let kikurageName = self.baseView.kikurageNameTextField.text,
              let cultivationStartDate = self.baseView.cultivationStartDateTextField.text else {
            print("DEBUG: 入力されていない項目があります")
            return false
        }
        if productKey.isEmpty || kikurageName.isEmpty || cultivationStartDate.isEmpty {
            print("DEBUG: 入力されていない項目があります")
            return false
        }
        return true
    }
}
// MARK: - LoginViewModel Delegate Method
extension LoginViewController: LoginViewModelDelegate {
    func didSuccessGetKikurageState() {
        // ユーザーを登録する
        self.viewModel.registerKikurageUser()
    }
    func didFailedGetKikurageState(errorMessage: String) {
        // HUD表示（終）
        HUD.hide()
        // アラート表示
        UIAlertController.showAlert(style: .alert, viewController: self, title: "プロダクトキーが違います", message: nil, okButtonTitle: "OK", cancelButtonTitle: nil, completionOk: nil)
        print(errorMessage)
    }
    func didSuccessPostKikurageUser() {
        // HUD表示（終）
        HUD.hide()
        self.transitionHomePage()
    }
    func didFailedPostKikurageUser(errorMessage: String) {
        // HUD表示（終）
        HUD.hide()
        // アラート表示
        UIAlertController.showAlert(style: .alert, viewController: self, title: "ユーザー登録に失敗しました", message: nil, okButtonTitle: "OK", cancelButtonTitle: nil, completionOk: nil)
        print(errorMessage)
    }
    private func transitionHomePage() {
        // NavigationControllerへの遷移になるのでViewControllerにStoryboardからIDを設定してUIViewControllerでインスタンス化する
        let s: UIStoryboard = UIStoryboard(name: "MainViewController", bundle: nil)
        let vc: UINavigationController = s.instantiateViewController(withIdentifier: "MainViewController") as! UINavigationController
        // MainViewController（トップ画面）への値渡し
        let mainVC = vc.topViewController as! MainViewController
        mainVC.kikurageState = self.viewModel.kikurageState
        mainVC.kikurageUser = self.viewModel.kikurageUser
        // 画面遷移
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
}
