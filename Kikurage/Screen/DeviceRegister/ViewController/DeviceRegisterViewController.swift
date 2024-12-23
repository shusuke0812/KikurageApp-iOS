//
//  DeviceRegisterViewController.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2019/03/22.
//  Copyright © 2019 shusuke. All rights reserved.
//

import AVFoundation
import KikurageFeature
import PKHUD
import UIKit

class DeviceRegisterViewController: UIViewController, UIViewControllerNavigatable, TopAccessable {
    private var baseView = DeviceRegisterBaseView()
    private var viewModel: DeviceRegisterViewModel!
    private var qrCodeReaderViewModel: KikurageQRCodeReaderViewModel!

    private let queue = DispatchQueue.global(qos: .userInitiated)

    // MARK: - Lifecycle

    override func loadView() {
        view = baseView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = DeviceRegisterViewModel(kikurageStateRepository: KikurageStateRepository(), kikurageUserRepository: KikurageUserRepository())
        qrCodeReaderViewModel = KikurageQRCodeReaderViewModel()
        qrCodeReaderViewModel.delegate = self
        setDelegateDataSource()

        navigationItem.title = R.string.localizable.screen_device_register_title()
        navigationItem.hidesBackButton = true
        adjustNavigationBarBackgroundColor()

        baseView.showKikurageQrcodeReaderView(isHidden: true)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        baseView.qrcodeReaderView.configPreviewLayer(captureSession: qrCodeReaderViewModel.captureSession)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        FirebaseAnalyticsHelper.sendScreenViewEvent(.deviceRegister)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        qrCodeReaderViewModel.removeCaptureSession()
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
        guard let text = textField.text else {
            return
        }
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
        let date: Date = baseView.cultivationStartDateTextField.date
        let dataString: String = DateHelper.formatToString(date: date)
        baseView.cultivationStartDateTextField.text = dataString
        viewModel.kikurageUser?.cultivationStartDate = date
    }
}

// MARK: - DeviceRegisterBaseView Delegate

extension DeviceRegisterViewController: DeviceRegisterBaseViewDelegate {
    func deviceRegisterBaseViewDidTappedDeviceRegisterButton(_ deviceRegisterBaseView: DeviceRegisterBaseView) {
        let validate = viewModel.validateRegistration(
            productKey: baseView.productKeyTextField.text,
            kikurageName: baseView.kikurageNameTextField.text,
            cultivationStartDateString: baseView.cultivationStartDateTextField.text
        )
        if validate {
            HUD.show(.progress)
            viewModel.loadKikurageState()
        } else {
            UIAlertController.showAlert(style: .alert, viewController: self, title: "入力されていない\n項目があります", message: nil, okButtonTitle: "OK", cancelButtonTitle: nil, completionOk: nil)
        }
    }

    func deviceRegisterBaseViewDidTappedQrcodeReaderButton(_ deviceRegisterBaseView: DeviceRegisterBaseView) {
        DispatchQueue.main.async {
            guard self.baseView.qrcodeReaderView.isHidden else {
                return
            }
            self.baseView.showKikurageQrcodeReaderView(isHidden: false)
        }
        qrCodeReaderViewModel.startRunning()
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
        guard let kikurageState = viewModel.kikurageState, let kikurageUser = viewModel.kikurageUser else {
            return
        }
        pushToHome(kikurageState: kikurageState, kikurageUser: kikurageUser)
    }
}

// MARK: - KikurageQRCodeReaderViewModel Delegate

extension DeviceRegisterViewController: KikurageQRCodeReaderViewModelDelegate {
    func qrCodeReaderViewModel(_ qrCodeReaderViewModel: KikurageQRCodeReaderViewModel, didConfigured captureSession: AVCaptureSession) {
        DispatchQueue.main.async {
            if let videoOrientation = AVCaptureVideoOrientation(interfaceOrientation: self.baseView.qrcodeReaderView.windowOrientation) {
                self.baseView.qrcodeReaderView.configCaptureOrientation(videoOrientation)
            }
            self.baseView.qrcodeReaderView.configPreviewLayer(captureSession: qrCodeReaderViewModel.captureSession)
        }
    }

    func qrCodeReaderViewModel(_ qrCodeReaderViewModel: KikurageQRCodeReaderViewModel, didFailedConfigured captureSession: AVCaptureSession, error: SessionSetupError) {}
    func qrCodeReaderViewModel(_ qrCodeReaderViewModel: KikurageQRCodeReaderViewModel, authorize: SessionSetupResult) {}
    func qrCodeReaderViewModel(_ qrCodeReaderViewModel: KikurageQRCodeReaderViewModel, interruptionEnded captureSession: AVCaptureSession) {}
    func qrCodeReaderViewModel(_ qrCodeReaderViewModel: KikurageQRCodeReaderViewModel, interrupted reason: AVCaptureSession.InterruptionReason) {}

    func qrCodeReaderViewModel(_ qrCodeReaderViewModel: KikurageQRCodeReaderViewModel, didRead qrCodeString: String) {
        DispatchQueue.main.async {
            self.baseView.showKikurageQrcodeReaderView(isHidden: true)
            self.baseView.setProductKeyText(qrCodeString)
        }
        viewModel.kikurageUser?.productKey = qrCodeString
        viewModel.setStateReference(productKey: qrCodeString)
    }

    func qrCodeReaderViewModel(_ qrCodeReaderViewModel: KikurageQRCodeReaderViewModel, didNotRead error: SessionSetupError) {
        DispatchQueue.main.async {
            self.baseView.showKikurageQrcodeReaderView(isHidden: true)
        }
    }
}
