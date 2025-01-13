//
//  DeviceRegisterViewModel.swift
//  KikurageService
//
//  Created by Shusuke Ota on 2021/1/7.
//  Copyright © 2021 shusuke. All rights reserved.
//

import KDEntity
import KDLoginManager
import KDRepository
import KSSDateHelper
import UIKit

public protocol DeviceRegisterViewModelDelegate: AnyObject {
    func deviceRegisterViewModelDidSuccessGetKikurageState(_ deviceRegisterViewModel: DeviceRegisterViewModel)
    func deviceRegisterViewModelDidFailedGetKikurageState(_ deviceRegisterViewMode: DeviceRegisterViewModel, with errorMessage: String)
    func deviceRegisterViewModelDidSuccessPostKikurageUser(_ deviceRegisterViewModel: DeviceRegisterViewModel)
    func deviceRegisterViewModelDidFailedPostKikurageUser(_ deviceRegisterViewModel: DeviceRegisterViewModel, with errorMessage: String)
}

public class DeviceRegisterViewModel {
    private let kikurageStateRepository: KikurageStateRepositoryProtocol
    private let kikurageUserRepository: KikurageUserRepositoryProtocol
    private let loginManager: LoginManager
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
        kikurageUser = KikurageUser()
    }

    public func getDateString(date: Date) -> String {
        DateHelper.formatToString(date: date)
    }
}

// MARK: - Setting Data

extension DeviceRegisterViewModel {
    /// ユーザーにステートのリファレンスを登録する
    public func setStateReference(productKey: String) {
        kikurageUser?.setStateRef(productKey: productKey)
    }

    public func validateRegistration(productKey: String?, kikurageName: String?, cultivationStartDateString: String?) -> Bool {
        guard let productKey = productKey, let kikurageName = kikurageName, let cultivationStartDateString = cultivationStartDateString else {
            return false
        }
        if productKey.isEmpty || kikurageName.isEmpty || cultivationStartDateString.isEmpty {
            return false
        }
        return true
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
