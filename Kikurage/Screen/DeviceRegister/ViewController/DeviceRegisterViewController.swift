//
//  DeviceRegisterViewController.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2019/03/22.
//  Copyright © 2019 shusuke. All rights reserved.
//

import AVFoundation
import KDEntity
import KAAnalytics
import KSDeviceRegisterService
import PKHUD
import UIKit

class DeviceRegisterViewController: UIViewController, UIViewControllerNavigatable, DeviceRegisterAccessable {
    private var baseView: DeviceRegisterBaseView!
    private var viewModel: DeviceRegisterViewModel!
    private var qrCodeReaderViewModel: QRCodeReaderViewModel!

    private let queue = DispatchQueue.global(qos: .userInitiated)

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = DeviceRegisterViewModel()
        qrCodeReaderViewModel = QRCodeReaderViewModel()
        qrCodeReaderViewModel.delegate = self

        baseView = DeviceRegisterBaseView(delegate: self, state: viewModel.state)
        addBaseView(baseView: baseView)

        viewModel.delegate = self

        navigationItem.title = R.string.localizable.screen_device_register_title()
        navigationItem.hidesBackButton = true
        adjustNavigationBarBackgroundColor()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        viewModel.setCaptureSession(qrCodeReaderViewModel.captureSession)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        FirebaseAnalyticsManager.sendScreenViewEvent(.deviceRegister)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        qrCodeReaderViewModel.removeCaptureSession()
    }
}

// MARK: - DeviceRegisterBaseView Delegate

extension DeviceRegisterViewController: DeviceRegisterBaseViewDelegate {
    func deviceRegisterBaseViewDidTappedDeviceRegisterButton() {
        HUD.show(.progress)
        viewModel.registerDevice()
    }

    func deviceRegisterBaseViewDidTappedQrcodeReaderButton() {
        DispatchQueue.main.async {
            guard !self.viewModel.state.isQrcodeReaderVisible else {
                return
            }
            self.viewModel.state.isQrcodeReaderVisible = true
        }
        qrCodeReaderViewModel.startRunning()
    }
}

// MARK: - LoginViewModel Delegate

extension DeviceRegisterViewController: DeviceRegisterViewModelDelegate {
    func deviceRegisterViewModelDidFailedValidation(_ deviceRegisterViewModel: DeviceRegisterViewModel) {
        DispatchQueue.main.async {
            HUD.hide()
            UIAlertController.showAlert(style: .alert, viewController: self, title: "入力されていない\n項目があります", message: nil, okButtonTitle: "OK", cancelButtonTitle: nil, completionOk: nil)
        }
    }

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

extension DeviceRegisterViewController: QRCodeReaderViewModelDelegate {
    func qrCodeReaderViewModel(_ qrCodeReaderViewModel: QRCodeReaderViewModel, didConfigured captureSession: AVCaptureSession) {
        DispatchQueue.main.async {
            let interfaceOrientation = self.view.window?.windowScene?.interfaceOrientation ?? .unknown
            let videoOrientation = AVCaptureVideoOrientation(interfaceOrientation: interfaceOrientation)
            self.viewModel.didConfigureCaptureSession(captureSession: captureSession, videoOrientation: videoOrientation)
        }
    }

    func qrCodeReaderViewModel(_ qrCodeReaderViewModel: QRCodeReaderViewModel, didFailedConfigured captureSession: AVCaptureSession, error: SessionSetupError) {}
    func qrCodeReaderViewModel(_ qrCodeReaderViewModel: QRCodeReaderViewModel, authorize: SessionSetupResult) {}
    func qrCodeReaderViewModel(_ qrCodeReaderViewModel: QRCodeReaderViewModel, interruptionEnded captureSession: AVCaptureSession) {}
    func qrCodeReaderViewModel(_ qrCodeReaderViewModel: QRCodeReaderViewModel, interrupted reason: AVCaptureSession.InterruptionReason) {}

    func qrCodeReaderViewModel(_ qrCodeReaderViewModel: QRCodeReaderViewModel, didRead qrCodeString: String) {
        viewModel.didReadQrCode(qrCodeString: qrCodeString)
    }

    func qrCodeReaderViewModel(_ qrCodeReaderViewModel: QRCodeReaderViewModel, didNotRead error: SessionSetupError) {
        viewModel.didNotReadQrCode()
    }
}
