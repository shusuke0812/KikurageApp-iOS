//
//  LoginViewModel.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2021/1/7.
//  Copyright © 2021 shusuke. All rights reserved.
//

import UIKit
import Firebase

protocol DeviceRegisterViewModelDelegate: AnyObject {
    /// きくらげの状態データ取得に成功した
    func didSuccessGetKikurageState()
    /// きくらげの状態データ取得に失敗した
    /// - Parameter errorMessage: エラーメッセージ
    func didFailedGetKikurageState(errorMessage: String)
    /// きくらげユーザーの登録に成功した
    func didSuccessPostKikurageUser()
    /// きくらげユーザーの登録に失敗した
    /// - Parameter errorMessage: エラーメッセージ
    func didFailedPostKikurageUser(errorMessage: String)
}

class DeviceRegisterViewModel {
    private let kikurageStateRepository: KikurageStateRepositoryProtocol
    private let kikurageUserRepository: KikurageUserRepositoryProtocol
    /// きくらげの状態
    var kikurageState: KikurageState?
    /// きくらげユーザー
    var kikurageUser: KikurageUser?

    weak var delegate: DeviceRegisterViewModelDelegate?

    init(kikurageStateRepository: KikurageStateRepositoryProtocol, kikurageUserRepository: KikurageUserRepositoryProtocol) {
        self.kikurageStateRepository = kikurageStateRepository
        self.kikurageUserRepository = kikurageUserRepository
        self.kikurageUser = KikurageUser()
    }
}

// MARK: - Setting Data

extension DeviceRegisterViewModel {
    /// ユーザーにステートのリファレンスを登録する
    func setStateReference(productKey: String) {
        kikurageUser?.stateRef = Firestore.firestore().document("/" + Constants.FirestoreCollectionName.states + "/\(productKey)")
    }
}

// MARK: - Firebase Firestore

extension DeviceRegisterViewModel {
    /// きくらげの状態を読み込む
    func loadKikurageState() {
        let productId = (kikurageUser?.productKey)!    // swiftlint:disable:this force_unwrapping
        kikurageStateRepository.getKikurageState(productId: productId) { [weak self] response in
            switch response {
            case .success(let kikurageState):
                self?.kikurageState = kikurageState
                self?.delegate?.didSuccessGetKikurageState()
            case .failure(let error):
                self?.delegate?.didFailedGetKikurageState(errorMessage: error.description())
            }
        }
    }
    /// きくらげユーザーを登録する
    func registerKikurageUser() {
        guard let kikurageUser = kikurageUser else {
            delegate?.didFailedPostKikurageUser(errorMessage: R.string.localizable.common_load_user_error())
            return
        }
        guard let uid = LoginHelper.shared.kikurageUserId else { return }
        kikurageUserRepository.postKikurageUser(uid: uid, kikurageUser: kikurageUser) { [weak self] responsse in
            switch responsse {
            case .success():
                self?.delegate?.didSuccessPostKikurageUser()
            case .failure(let error):
                self?.delegate?.didFailedPostKikurageUser(errorMessage: error.description())
            }
        }
    }
}
