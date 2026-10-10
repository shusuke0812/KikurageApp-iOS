//
//  DeviceRegisterViewModel.swift
//  KikurageService
//
//  Created by Shusuke Ota on 2021/1/7.
//  Copyright © 2021 shusuke. All rights reserved.
//

import AVFoundation
import Combine
import KDEntity
import KDLoginManager
import KDRepository
import KSSDateHelper
import UIKit

public protocol DeviceRegisterViewModelDelegate: AnyObject {
    func deviceRegisterViewModelDidFailedValidation(_ deviceRegisterViewModel: DeviceRegisterViewModel)
    func deviceRegisterViewModelDidSuccessGetKikurageState(_ deviceRegisterViewModel: DeviceRegisterViewModel)
    func deviceRegisterViewModelDidFailedGetKikurageState(_ deviceRegisterViewMode: DeviceRegisterViewModel, with errorMessage: String)
    func deviceRegisterViewModelDidSuccessPostKikurageUser(_ deviceRegisterViewModel: DeviceRegisterViewModel)
    func deviceRegisterViewModelDidFailedPostKikurageUser(_ deviceRegisterViewModel: DeviceRegisterViewModel, with errorMessage: String)
}

public class DeviceRegisterViewModel {
    private let kikurageStateRepository: KikurageStateRepositoryProtocol
    private let kikurageUserRepository: KikurageUserRepositoryProtocol
    private let loginManager: LoginManager
    /// 入力状態
    public var state: DeviceRegisterState
    /// きくらげの状態
    public var kikurageState: KikurageState?
    /// きくらげユーザー
    public var kikurageUser: KikurageUser?

    public weak var delegate: DeviceRegisterViewModelDelegate?

    public init(
        kikurageStateRepository: KikurageStateRepositoryProtocol = KikurageStateRepository(),
        kikurageUserRepository: KikurageUserRepositoryProtocol = KikurageUserRepository()
    ) {
        self.kikurageStateRepository = kikurageStateRepository
        self.kikurageUserRepository = kikurageUserRepository
        loginManager = LoginManager()
        state = DeviceRegisterState()

        state.$productKey.combineLatest(state.$kikurageName, state.$cultivationStartDate)
            .map { productKey, kikurageName, cultivationStartDate in
                let cultivationStartDateString = DateHelper.formatToString(date: cultivationStartDate)
                return !(productKey.isEmpty || kikurageName.isEmpty || cultivationStartDateString.isEmpty)
            }
            .assign(to: &state.$canRegister)
    }

    public func getDateString(date: Date) -> String {
        DateHelper.formatToString(date: date)
    }
}

// MARK: - Setting Data

extension DeviceRegisterViewModel {
    /// デバイス登録ボタンタップ時の処理（ViewController から呼ぶ）
    public func registerDevice() {
        if state.canRegister {
            kikurageUser = KikurageUser(
                productKey: state.productKey,
                kikurageName: state.kikurageName,
                cultivationStartDate: state.cultivationStartDate
            )
            setStateReference(productKey: state.productKey)
            loadKikurageState()
        } else {
            delegate?.deviceRegisterViewModelDidFailedValidation(self)
        }
    }

    /// ユーザーにステートのリファレンスを登録する
    private func setStateReference(productKey: String) {
        kikurageUser?.setStateRef(productKey: productKey)
    }

    public func didReadQrCode(qrCodeString: String) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.state.isQrcodeReaderVisible = false
            self.state.productKey = qrCodeString
        }
        self.kikurageUser = KikurageUser(
            productKey: qrCodeString,
            kikurageName: self.state.kikurageName,
            cultivationStartDate: self.state.cultivationStartDate
        )
        self.setStateReference(productKey: qrCodeString)
    }

    public func didNotReadQrCode() {
        DispatchQueue.main.async { [weak self] in
            self?.state.isQrcodeReaderVisible = false
        }
    }

    /// キャプチャセッション設定時の処理（ViewController から captureSession と videoOrientation を渡す）
    public func didConfigureCaptureSession(captureSession: AVCaptureSession, videoOrientation: AVCaptureVideoOrientation?) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.state.videoOrientation = videoOrientation
            self.state.captureSession = captureSession
        }
    }

    /// キャプチャセッションを更新（viewDidLayoutSubviews 等から呼ぶ）
    public func setCaptureSession(_ captureSession: AVCaptureSession?) {
        state.captureSession = captureSession
    }
}

// MARK: - Firebase Firestore

extension DeviceRegisterViewModel {
    /// きくらげの状態を読み込む
    public func loadKikurageState() {
        let productID = (kikurageUser?.productKey)! // swiftlint:disable:this force_unwrapping
        let request = KikurageStateRequest(productID: productID)
        kikurageStateRepository.getKikurageState(request: request) { [weak self] response in
            switch response {
            case .success(let kikurageState):
                self?.kikurageState = kikurageState
                self?.delegate?.deviceRegisterViewModelDidSuccessGetKikurageState(self!)
            case .failure(let error):
                self?.delegate?.deviceRegisterViewModelDidFailedGetKikurageState(self!, with: error.description())
            }
        }
    }

    /// きくらげユーザーを登録する
    public func registerKikurageUser() {
        guard let kikurageUser = kikurageUser else {
            delegate?.deviceRegisterViewModelDidFailedPostKikurageUser(self, with: "error") // TODO: R.string.localizable.common_load_user_error() に置き換え
            return
        }
        guard let uid = loginManager.userID else {
            delegate?.deviceRegisterViewModelDidFailedPostKikurageUser(self, with: "error") // TODO: R.string.localizable.common_load_user_error()
            return
        }
        var request = KikurageUserRequest(uid: uid)
        request.body = request.buildBody(from: kikurageUser)
        kikurageUserRepository.postKikurageUser(request: request) { [weak self] responsse in
            switch responsse {
            case .success():
                self?.delegate?.deviceRegisterViewModelDidSuccessPostKikurageUser(self!)
                self?.kikurageUser = kikurageUser
            case .failure(let error):
                self?.delegate?.deviceRegisterViewModelDidFailedPostKikurageUser(self!, with: error.description())
            }
        }
    }
}
