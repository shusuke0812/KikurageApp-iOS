//
//  LoginViewModel.swift
//  kikurageApp
//
//  Created by Shusuke Ota on 2021/9/12.
//  Copyright © 2021 shusuke. All rights reserved.
//

import Foundation
import Firebase

protocol LoginViewModelDelegate: AnyObject {
    /// ログインに成功した
    func didSuccessLogin()
    /// ログインに失敗した
    /// - Parameter errorMessage: エラーメッセージ
    func didFailedLogin(errorMessage: String)
}

class LoginViewModel {
    /// ログインリポジトリ
    private var loginRepository: LoginRepositoryProtocol
    /// きくらげの状態取得リポジトリ
    private var kikurageStateRepository: KikurageStateRepositoryProtocol
    /// きくらげのユーザー取得リポジトリ
    private var kikurageUserRepository: KikurageUserRepositoryProtocol

    weak var delegate: LoginViewModelDelegate?

    var kikurageUser: KikurageUser?
    var kikurageState: KikurageState?

    private var user: User?
    var email: String = ""
    var password: String = ""

    init(loginRepository: LoginRepositoryProtocol, kikurageStateRepository: KikurageStateRepositoryProtocol, kikurageUserRepository: KikurageUserRepositoryProtocol) {
        self.loginRepository = loginRepository
        self.kikurageStateRepository = kikurageStateRepository
        self.kikurageUserRepository = kikurageUserRepository
    }
}

// MARK: - Setting Data
extension LoginViewModel {
    private func setLoginInfo() -> (email: String, password: String) {
        (self.email, self.password)
    }
    func initLoginInfo() {
        self.email = ""
        self.password = ""
    }
    // TODO: email, password の入力バリデーション処理を追加（`VC`の登録ボタン押下時に呼ぶ）
}

// MARK: - Firebase Authentication
extension LoginViewModel {
    func login() {
        let loginInfo = self.setLoginInfo()
        self.loginRepository.login(loginInfo: loginInfo) { [weak self] response in
            switch response {
            case .success(let user):
                self?.user = user
                self?.loadKikurageUser()
            case .failure(let error):
                print("DEBUG: \(error)")
                self?.delegate?.didFailedLogin(errorMessage: "ユーザーログインに失敗しました")
            }
        }
    }
}

// MARK: - Firebase Firestore
extension LoginViewModel {
    /// きくらげユーザーを読み込む
    private func loadKikurageUser() {
        self.kikurageUserRepository.getKikurageUser(uid: (self.user?.uid)!) { [weak self] response in   // swiftlint:disable:this force_unwrapping
            switch response {
            case .success(let kikurageUser):
                self?.kikurageUser = kikurageUser
                self?.loadKikurageState()
            case .failure(let error):
                print("DEBUG: \(error)")
                self?.delegate?.didFailedLogin(errorMessage: "きくらげユーザーの取得に失敗しました")
            }
        }
    }
    /// きくらげの状態を読み込む
    private func loadKikurageState() {
        let productId = (self.kikurageUser?.productKey)!    // swiftlint:disable:this force_unwrapping
        self.kikurageStateRepository.getKikurageState(productId: productId) { [weak self] response in
            switch response {
            case .success(let kikurageState):
                self?.kikurageState = kikurageState
                self?.delegate?.didSuccessLogin()
            case .failure(let error):
                print("DEBUG: \(error)")
                self?.delegate?.didFailedLogin(errorMessage: "きくらげ状態の取得に失敗しました")
            }
        }
    }
}
