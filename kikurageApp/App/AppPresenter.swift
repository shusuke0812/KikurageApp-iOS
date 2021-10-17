//
//  AppPresenter.swift
//  kikurageApp
//
//  Created by Shusuke Ota on 2021/9/4.
//  Copyright © 2021 shusuke. All rights reserved.
//

import Foundation
import Firebase

protocol AppPresenterDelegate: AnyObject {
    /// きくらげ情報の取得に成功した
    func didSuccessGetKikurageInfo(kikurageInfo: (user: KikurageUser?, state: KikurageState?))
    /// きくらげ情報の取得に失敗した
    /// - Parameter errorMessage: エラーメッセージ
    func didFailedGetKikurageInfo(errorMessage: String)
}

class AppPresenter {
    private var kikurageStateRepository: KikurageStateRepositoryProtocol
    private let kikurageUserRepository: KikurageUserRepositoryProtocol

    weak var delegate: AppPresenterDelegate?

    private var kikurageUser: KikurageUser?
    private var kikurageState: KikurageState?

    init(kikurageStateRepository: KikurageStateRepositoryProtocol, kikurageUserRepository: KikurageUserRepositoryProtocol) {
        self.kikurageStateRepository = kikurageStateRepository
        self.kikurageUserRepository = kikurageUserRepository
    }
}

// MARK: - Firebase Firestore
extension AppPresenter {
    /// きくらげユーザーを取得する
    /// - Parameter userId: Firebase ユーザーID
    func loadKikurageUser(userId: String) {
        kikurageUserRepository.getKikurageUser(uid: userId) { [weak self] response in
            switch response {
            case .success(let kikurageUser):
                self?.kikurageUser = kikurageUser
                self?.loadKikurageState()
            case .failure(let error):
                print(error)
                self?.delegate?.didFailedGetKikurageInfo(errorMessage: "きくらげユーザーの取得に失敗しました")
            }
        }
    }
    /// きくらげの状態を読み込む
    private func loadKikurageState() {
        let productId = (kikurageUser?.productKey)!    // swiftlint:disable:this force_unwrapping
        kikurageStateRepository.getKikurageState(productId: productId) { [weak self] response in
            switch response {
            case .success(let kikurageState):
                self?.kikurageState = kikurageState
                self?.delegate?.didSuccessGetKikurageInfo(kikurageInfo: (user: self?.kikurageUser, state: self?.kikurageState))
            case .failure(let error):
                print("DEBUG: \(error)")
                self?.delegate?.didFailedGetKikurageInfo(errorMessage: "きくらげ状態の取得に失敗しました")
            }
        }
    }
}
