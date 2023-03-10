//
//  LoginViewModel.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2021/9/12.
//  Copyright © 2021 shusuke. All rights reserved.
//

import Foundation

protocol LoginViewModelDelegate: AnyObject {
    func loginViewModelDidSuccessLogin(_ loginViewModel: LoginViewModel)
    func loginViewModelDidFailedLogin(_ loginViewModel: LoginViewModel, with errorMessage: String)
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
            case let .success(loginUser):
                self?.loginUser = loginUser
                self?.loadKikurageUser()
            case let .failure(error):
                self?.delegate?.loginViewModelDidFailedLogin(self!, with: error.description())
            }
        }
    }
}

// MARK: - Firebase Firestore

extension LoginViewModel {
    /// きくらげユーザーを読み込む
    private func loadKikurageUser() {
        let request = KikurageUserRequest(uid: (loginUser?.uid)!)
        kikurageUserRepository.getKikurageUser(request: request) { [weak self] response in // swiftlint:disable:this force_unwrapping
            switch response {
            case let .success(kikurageUser):
                self?.kikurageUser = kikurageUser
                self?.loadKikurageState()
            case let .failure(error):
                self?.delegate?.loginViewModelDidFailedLogin(self!, with: error.description())
            }
        }
    }

    /// きくらげの状態を読み込む
    private func loadKikurageState() {
        let productID = (kikurageUser?.productKey)! // swiftlint:disable:this force_unwrapping
        let request = KikurageStateRequest(productID: productID)
        kikurageStateRepository.getKikurageState(request: request) { [weak self] response in
            switch response {
            case let .success(kikurageState):
                self?.kikurageState = kikurageState
                self?.delegate?.loginViewModelDidSuccessLogin(self!)
            case let .failure(error):
                self?.delegate?.loginViewModelDidFailedLogin(self!, with: error.description())
            }
        }
    }
}
