//
//  loginViewController.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2019/03/22.
//  Copyright © 2019 shusuke. All rights reserved.
//

import UIKit
import PKHUD
import KikurageFeature

class DeviceRegisterViewController: UIViewController, UIViewControllerNavigatable {
    private var baseView: DeviceRegisterBaseView { self.view as! DeviceRegisterBaseView } // swiftlint:disable:this force_cast
    private var viewModel: DeviceRegisterViewModel!

    private let queue = DispatchQueue.global(qos: .userInitiated)

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = DeviceRegisterViewModel(kikurageStateRepository: KikurageStateRepository(), kikurageUserRepository: KikurageUserRepository())
        setDelegateDataSource()

        navigationItem.title = R.string.localizable.screen_device_register_title()
        navigationItem.hidesBackButton = true
        adjustNavigationBarBackgroundColor()

        baseView.showKikurageQrcodeReaderView(isHidden: true)
        baseView.kikurageQrcodeReaderView.readQRcodeString = { [weak self] qrcode in
            self?.baseView.showKikurageQrcodeReaderView(isHidden: true)
            self?.baseView.setProductKeyText(qrcode)
            self?.viewModel.kikurageUser?.productKey = qrcode
            self?.viewModel.setStateReference(productKey: qrcode)
        }
        baseView.kikurageQrcodeReaderView.catchError = { error in
            if #available(iOS 14, *) {
                KLogManager.error(error.localizedDescription)
            }
        }
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        baseView.kikurageQrcodeReaderView.configPreviewLayer()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
}

// MARK: - Initialized

extension DeviceRegisterViewController {
    private func setDelegateDataSource() {
        baseView.delegate = self
        baseView.configTextField(delegate: self)
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
    func deviceRegisterBaseViewDidTappedDeviceRegisterButton(_ deviceRegisterBaseView: DeviceRegisterBaseView) {
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
    func deviceRegisterBaseViewDidTappedQrcodeReaderButton(_ deviceRegisterBaseView: DeviceRegisterBaseView) {
        guard baseView.kikurageQrcodeReaderView.isHidden else { return }
        baseView.showKikurageQrcodeReaderView(isHidden: false)
        queue.async { [weak self] in
            // TODO: KikurageFeature内にてAVCaptureSessionとCaptureをUIViewに反映する処理を分ける（baseViewのメソッドをserial queueで実行すると`UIViewController.view must be used from main thread only`アラートが出てしまうため）
            self?.baseView.kikurageQrcodeReaderView.startRunning()
        }
    }
}

// MARK: - LoginViewModel Delegate

extension DeviceRegisterViewController: DeviceRegisterViewModelDelegate {
    func deviceRegisterViewModelDidSuccessGetKikurageState(_ deviceRegisterViewModel: DeviceRegisterViewModel) {
        deviceRegisterViewModel.registerKikurageUser()
    }
    func deviceRegisterViewModelDidFailedGetKikurageState(_ deviceRegisterViewMode: DeviceRegisterViewModel, with errorMessage: String) {
        DispatchQueue.main.async {
            HUD.hide()
            UIAlertController.showAlert(style: .alert, viewController: self, title: errorMessage, message: nil, okButtonTitle: "OK", cancelButtonTitle: nil, completionOk: nil)
        }
    }
    func deviceRegisterViewModelDidSuccessPostKikurageUser(_ deviceRegisterViewModel: DeviceRegisterViewModel) {
        DispatchQueue.main.async {
            HUD.hide()
            self.transitionHomePage()
        }
    }
    func deviceRegisterViewModelDidFailedPostKikurageUser(_ deviceRegisterViewModel: DeviceRegisterViewModel, with errorMessage: String) {
        DispatchQueue.main.async {
            HUD.hide()
            UIAlertController.showAlert(style: .alert, viewController: self, title: errorMessage, message: nil, okButtonTitle: "OK", cancelButtonTitle: nil, completionOk: nil)
        }
    }
    private func transitionHomePage() {
        guard let vc = R.storyboard.homeViewController.instantiateInitialViewController() else { return }
        vc.kikurageState = viewModel.kikurageState
        vc.kikurageUser = viewModel.kikurageUser
        navigationController?.pushViewController(vc, animated: true)
    }
}
