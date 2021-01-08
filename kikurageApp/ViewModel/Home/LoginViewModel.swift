//
//  LoginViewModel.swift
//  kikurageApp
//
//  Created by Shusuke Ota on 2021/1/7.
//  Copyright © 2021 shusuke. All rights reserved.
//

import UIKit
import Firebase

protocol LoginViewModelDelegate: class {
    /// きくらげの状態データ取得に成功した
    func didSuccessGetKikurageState()
    /// きくらげの状態データ取得に失敗した
    /// - Parameter errorMessage: エラーメッセージ
    func didFailedGetKikurageState(errorMessage: String)
    /// きくらげユーザーの取得に成功した
    func didSuccessGetKikurageUser()
    /// きくらげユーザーの取得に失敗した
    /// - Parameter errorMessage: エラーメッセージ
    func didFailedGetKikurageUser(errorMessage: String)
}

class LoginViewModel {
    /// きくらげの状態取得リポジトリ
    private let kikurageStateRepository: KikurageStateRepositoryProtocol
    /// きくらげユーザー取得リポジトリ
    private let kikurageUserRepository: KikurageUserRepositoryProtocol
    /// きくらげの状態ID（プロダクトキー ）
    var kikurageStateId: String?
    /// きくらげの状態
    var kikurageState: KikurageState?
    /// きくらげユーザー
    var kikurageUser: KikurageUser?
    /// デリゲート
    internal weak var delegate: LoginViewModelDelegate?
    
    init(kikurageStateRepository: KikurageStateRepositoryProtocol,
         kikurageUserRepository: KikurageUserRepositoryProtocol) {
        self.kikurageStateRepository = kikurageStateRepository
        self.kikurageUserRepository = kikurageUserRepository
    }
}
// MARK: - Firebase Firestore Method
extension LoginViewModel {
    /// きくらげの状態を読み込む
    func loadKikurageState() {
        guard let productId = self.kikurageStateId else { return }
        self.kikurageStateRepository
            .getKikurageState(productId: productId,
                              completion: { response in
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
                              })
    }
    /// きくらげユーザーを読み込む
    /// - Parameter uid: ユーザーID
    func loadKikurageUser(uid: String) {
        self.kikurageUserRepository
            .getKikurageUser(uid: uid,
                             completion: { responsse in
                                 switch responsse {
                                 case .success(let kikurageUser):
                                     DispatchQueue.main.async { [weak self] in
                                        self?.kikurageUser = kikurageUser
                                        self?.delegate?.didSuccessGetKikurageUser()
                                     }
                                 case .failure(let error):
                                     print("DEBUG: \(error)")
                                     self.delegate?.didFailedGetKikurageUser(errorMessage: "きくらげユーザーを取得できませんでした")
                                 }
                             })
    }
}
