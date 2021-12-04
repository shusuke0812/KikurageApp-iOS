//
//  LoginViewModel.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2021/9/12.
//  Copyright © 2021 shusuke. All rights reserved.
//

import Foundation

protocol LoginViewModelDelegate: AnyObject {
    /// ログインに成功した
    func didSuccessLogin()
    /// ログインに失敗した
    /// - Parameter errorMessage: エラーメッセージ
    func didFailedLogin(errorMessage: String)
}

class LoginViewModel {
    private var signUpRepository: SignUpRepositoryProtocol
    private var loginRepository: LoginRepositoryProtocol
    private var kikurageStateRepository: KikurageStateRepositoryProtocol
    private var kikurageUserRepository: KikurageUserRepositoryProtocol

    weak var delegate: LoginViewModelDelegate?

    var kikurageUser: KikurageUser?
    var kikurageState: KikurageState?

    private var loginUser: LoginUser?
    var email: String = ""
    var password: String = ""

    init(signUpRepository: SignUpRepositoryProtocol, loginRepository: LoginRepositoryProtocol, kikurageStateRepository: KikurageStateRepositoryProtocol, kikurageUserRepository: KikurageUserRepositoryProtocol) {
        self.signUpRepository = signUpRepository
        self.loginRepository = loginRepository
        self.kikurageStateRepository = kikurageStateRepository
        self.kikurageUserRepository = kikurageUserRepository
    }
}

// MARK: - Setting Data
extension LoginViewModel {
    private func setLoginInfo() -> (email: String, password: String) {
        (email, password)
    }
    func initLoginInfo() {
        email = ""
        password = ""
    }
    // TODO: email, password の入力バリデーション処理を追加（`VC`の登録ボタン押下時に呼ぶ）
}

// MARK: - Firebase Authentication
extension LoginViewModel {
    func login() {
        let loginInfo = setLoginInfo()
        loginRepository.login(loginInfo: loginInfo) { [weak self] response in
            switch response {
            case .success(let loginUser):
                self?.loginUser = loginUser
                self?.loadKikurageUser()
            case .failure(let error):
                self?.delegate?.didFailedLogin(errorMessage: error.description())
            }
        }
    }
}

// MARK: - Firebase Firestore
extension LoginViewModel {
    /// きくらげユーザーを読み込む
    private func loadKikurageUser() {
        kikurageUserRepository.getKikurageUser(uid: (loginUser?.uid)!) { [weak self] response in   // swiftlint:disable:this force_unwrapping
            switch response {
            case .success(let kikurageUser):
                self?.kikurageUser = kikurageUser
                self?.loadKikurageState()
            case .failure(let error):
                self?.delegate?.didFailedLogin(errorMessage: error.description())
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
                self?.delegate?.didSuccessLogin()
            case .failure(let error):
                self?.delegate?.didFailedLogin(errorMessage: error.description())
            }
        }
    }
}
