//
//  loginViewController.swift
//  kikurageApp
//
//  Created by Shusuke Ota on 2019/03/22.
//  Copyright © 2019 shusuke. All rights reserved.
//

import UIKit
import PKHUD

class DeviceRegisterViewController: UIViewController {
    /// BaseView
    private var baseView: DeviceRegisterBaseView { self.view as! DeviceRegisterBaseView } // swiftlint:disable:this force_cast
    /// ViewModel
    private var viewModel: DeviceRegisterViewModel!

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = DeviceRegisterViewModel(kikurageStateRepository: KikurageStateRepository(), kikurageUserRepository: KikurageUserRepository())
        self.setDelegateDataSource()

        self.navigationItem.title = "デバイス登録"
        self.navigationItem.hidesBackButton = true
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
}
// MARK: - Initialized
extension DeviceRegisterViewController {
    private func setDelegateDataSource() {
        self.baseView.delegate = self
        self.baseView.productKeyTextField.delegate = self
        self.baseView.kikurageNameTextField.delegate = self
        self.baseView.cultivationStartDateTextField.delegate = self
        self.viewModel.delegate = self
    }
}
// MARK: - UITextField Delegate
extension DeviceRegisterViewController: UITextFieldDelegate {
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
        let dataString: String = DateHelper.shared.formatToString(date: date)
        self.baseView.cultivationStartDateTextField.text = dataString
        self.viewModel.kikurageUser?.cultivationStartDate = date
    }
}
// MARK: - DeviceRegisterBaseView Delegate
extension DeviceRegisterViewController: DeviceRegisterBaseViewDelegate {
    func didTappedDeviceRegisterButton() {
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
    // TODO: TextFieldバリデーションはViewModelに書く
    private func textFieldValidation() -> Bool {
        guard let productKey = self.baseView.productKeyTextField.text, let kikurageName = self.baseView.kikurageNameTextField.text, let cultivationStartDate = self.baseView.cultivationStartDateTextField.text else {
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
// MARK: - LoginViewModel Delegate
extension DeviceRegisterViewController: DeviceRegisterViewModelDelegate {
    func didSuccessGetKikurageState() {
        self.viewModel.registerKikurageUser()
    }
    func didFailedGetKikurageState(errorMessage: String) {
        DispatchQueue.main.async {
            HUD.hide()
            UIAlertController.showAlert(style: .alert, viewController: self, title: "プロダクトキーが違います", message: nil, okButtonTitle: "OK", cancelButtonTitle: nil, completionOk: nil)
        }
        print(errorMessage)
    }
    func didSuccessPostKikurageUser() {
        DispatchQueue.main.async {
            HUD.hide()
            self.transitionHomePage()
        }
    }
    func didFailedPostKikurageUser(errorMessage: String) {
        DispatchQueue.main.async {
            HUD.hide()
            UIAlertController.showAlert(style: .alert, viewController: self, title: "ユーザー登録に失敗しました", message: nil, okButtonTitle: "OK", cancelButtonTitle: nil, completionOk: nil)
        }
        print(errorMessage)
    }
    private func transitionHomePage() {
        // NavigationControllerへの遷移になるのでViewControllerにStoryboardからIDを設定してUIViewControllerでインスタンス化する
        guard let nc = R.storyboard.mainViewController.instantiateInitialViewController() else { return }
        // MainViewController（トップ画面）への値渡し
        let vc = nc.topViewController as! MainViewController // swiftlint:disable:this force_cast
        vc.kikurageState = self.viewModel.kikurageState
        vc.kikurageUser = self.viewModel.kikurageUser
        // 画面遷移
        nc.modalPresentationStyle = .fullScreen
        self.present(nc, animated: true, completion: nil)
    }
}
