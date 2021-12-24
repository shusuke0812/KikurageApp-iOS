//
//  loginViewController.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2019/03/22.
//  Copyright © 2019 shusuke. All rights reserved.
//

import UIKit
import PKHUD

class DeviceRegisterViewController: UIViewController, UIViewControllerNavigatable {
    private var baseView: DeviceRegisterBaseView { self.view as! DeviceRegisterBaseView } // swiftlint:disable:this force_cast
    private var viewModel: DeviceRegisterViewModel!

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = DeviceRegisterViewModel(kikurageStateRepository: KikurageStateRepository(), kikurageUserRepository: KikurageUserRepository())
        setDelegateDataSource()

        navigationItem.title = "デバイス登録"
        navigationItem.hidesBackButton = true
        adjustNavigationBarBackgroundColor()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
}
// MARK: - Initialized
extension DeviceRegisterViewController {
    private func setDelegateDataSource() {
        baseView.delegate = self
        baseView.productKeyTextField.delegate = self
        baseView.kikurageNameTextField.delegate = self
        baseView.cultivationStartDateTextField.delegate = self
        viewModel.delegate = self
    }
}
// MARK: - UITextField Delegate
extension DeviceRegisterViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text else { return }
        switch textField {
        case baseView.productKeyTextField:
            viewModel.kikurageUser?.productKey = text
            viewModel.setStateReference(productKey: text)
        case baseView.kikurageNameTextField:
            viewModel.kikurageUser?.kikurageName = text
        case baseView.cultivationStartDateTextField:
            setCultivationStartDateTextFieldData()
        default:
            break
        }
    }
    private func setCultivationStartDateTextFieldData() {
        let date: Date = baseView.datePicker.date
        let dataString: String = DateHelper.formatToString(date: date)
        baseView.cultivationStartDateTextField.text = dataString
        viewModel.kikurageUser?.cultivationStartDate = date
    }
}
// MARK: - DeviceRegisterBaseView Delegate
extension DeviceRegisterViewController: DeviceRegisterBaseViewDelegate {
    func didTappedDeviceRegisterButton() {
        let validate = textFieldValidation()
        if validate {
            HUD.show(.progress)
            viewModel.loadKikurageState()
        } else {
            UIAlertController.showAlert(style: .alert, viewController: self, title: "入力されていない\n項目があります", message: nil, okButtonTitle: "OK", cancelButtonTitle: nil, completionOk: nil)
        }
    }
    // TODO: TextFieldバリデーションはViewModelに書く
    private func textFieldValidation() -> Bool {
        guard let productKey = baseView.productKeyTextField.text, let kikurageName = baseView.kikurageNameTextField.text, let cultivationStartDate = baseView.cultivationStartDateTextField.text else {
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
        viewModel.registerKikurageUser()
    }
    func didFailedGetKikurageState(errorMessage: String) {
        DispatchQueue.main.async {
            HUD.hide()
            UIAlertController.showAlert(style: .alert, viewController: self, title: errorMessage, message: nil, okButtonTitle: "OK", cancelButtonTitle: nil, completionOk: nil)
        }
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
            UIAlertController.showAlert(style: .alert, viewController: self, title: errorMessage, message: nil, okButtonTitle: "OK", cancelButtonTitle: nil, completionOk: nil)
        }
    }
    private func transitionHomePage() {
        guard let vc = R.storyboard.homeViewController.instantiateInitialViewController() else { return }
        vc.kikurageState = viewModel.kikurageState
        vc.kikurageUser = viewModel.kikurageUser
        
        let nc = UINavigationController(rootViewController: vc)
        nc.modalPresentationStyle = .fullScreen
        present(nc, animated: true, completion: nil)
    }
}
