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
        self.setDelegateDataSource()
        self.viewModel = LoginViewModel(kikurageStateRepository: KikurageStateRepository(),
                                        kikurageUserRepository: KikurageUserRepository())
    }
}
// MARK: - Initialized Method
extension LoginViewController {
    private func setDelegateDataSource() {
        self.baseView.delegate = self
        self.baseView.productKeyTextField.delegate = self
        self.baseView.kikurageNameTextField.delegate = self
        self.viewModel.delegate = self
    }
}
// MARK: - UITextField Delegate Method
extension LoginViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField.tag {
        case Constants.TextFieldTag.productKey:
            self.viewModel.kikurageStateId = self.baseView.productKeyTextField.text
        case Constants.TextFieldTag.kikurageName:
            self.viewModel.kikurageUser?.kikurageName = self.baseView.kikurageNameTextField.text
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
        self.viewModel.kikurageUser?.startDate = date
    }
}
// MARK: - LoginBaseView Delegate Method
extension LoginViewController: LoginBaseViewDelegate {
    func didTapLoginButton() {
        // HUD表示（始）
        HUD.show(.progress)
        // きくらげの状態を取得する
        self.viewModel.loadKikurageState()
    }
    func didTapTermsButton() {
        self.transitionSafariViewController(urlString: Constants.WebUrl.terms)
    }
    func didTapPrivacyPolicyButton() {
        self.transitionSafariViewController(urlString: Constants.WebUrl.privacyPolicy)
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
        let s = UIStoryboard(name: "MainViewController", bundle: nil)
        let vc = s.instantiateInitialViewController() as! MainViewController
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
}
