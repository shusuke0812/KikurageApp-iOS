//
//  LoginViewModel.swift
//  kikurageApp
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
    /// きくらげの状態取得リポジトリ
    private let kikurageStateRepository: KikurageStateRepositoryProtocol
    /// きくらげユーザー取得リポジトリ
    private let kikurageUserRepository: KikurageUserRepositoryProtocol
    /// きくらげの状態
    var kikurageState: KikurageState?
    /// きくらげユーザー
    var kikurageUser: KikurageUser?
    /// デリゲート
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
        self.kikurageUser?.stateRef = Firestore.firestore().document("/" + Constants.FirestoreCollectionName.states + "/\(productKey)")
    }
    /// UserDefaultsにユーザーIDを登録する
    func setUserIdToUserDefaults(userId: String) {
        UserDefaults.standard.set(userId, forKey: Constants.UserDefaultsKey.userId)
    }
}
// MARK: - Firebase Firestore
extension DeviceRegisterViewModel {
    /// きくらげの状態を読み込む
    func loadKikurageState() {
        guard let productId = self.kikurageUser?.productKey else { return }
        self.kikurageStateRepository.getKikurageState(productId: productId) { response in
            switch response {
            case .success(let kikurageState):
                DispatchQueue.main.async { [weak self] in
                    self?.kikurageState = kikurageState
                    self?.delegate?.didSuccessGetKikurageState()
                }
            case .failure(let error):
                print("DEBUG: \(error)")
                self.delegate?.didFailedGetKikurageState(errorMessage: "きくらげの状態を取得できませんでした")
            }
        }
    }
    /// きくらげユーザーを登録する
    /// - Parameter uid: ユーザーID
    func registerKikurageUser() {
        guard let kikurageUser = self.kikurageUser else {
            self.delegate?.didFailedPostKikurageUser(errorMessage: "きくらげユーザーを取得できませんでした")
            return
        }
        self.kikurageUserRepository.postKikurageUser(kikurageUser: kikurageUser) { [weak self] responsse in
            switch responsse {
            case .success(let kikurageUserDocumentReference):
                self?.setUserIdToUserDefaults(userId: kikurageUserDocumentReference.documentID)
                self?.delegate?.didSuccessPostKikurageUser()
            case .failure(let error):
                print("DEBUG: \(error)")
                self?.delegate?.didFailedPostKikurageUser(errorMessage: "きくらげユーザーを登録できませんでした")
            }
        }
    }
    /// きくらげユーザーを取得する
    /// - Parameter uid: ユーザーID
    func loadKikurageUser(uid: String) {
        self.kikurageUserRepository.getKikurageUser(uid: uid) { [weak self] response in
            switch response {
            case .success(let kikurageUser):
                self?.kikurageUser = kikurageUser
            case .failure(let error):
                print(error)
            }
        }
    }
}
