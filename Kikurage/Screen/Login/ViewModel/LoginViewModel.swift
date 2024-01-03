//
//  LoginViewModel.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2021/9/12.
//  Copyright © 2021 shusuke. All rights reserved.
//

import Foundation

protocol LoginViewModelDelegate: AnyObject {
    func loginViewModelDidSuccessLogin(_ loginViewModel: LoginViewModel?, user: KikurageUser, state: KikurageState)
    func loginViewModelDidFailedLogin(_ loginViewModel: LoginViewModel?, with errorMessage: String)
}

class LoginViewModel {
    private var signUpRepository: SignUpRepositoryProtocol
    private var loginRepository: LoginRepositoryProtocol
    private let loadKikurageStateWithUserUseCase: LoadKikurageStateWithUserUseCaseProtocol

    weak var delegate: LoginViewModelDelegate?

    private var loginUser: LoginUser?
    private var email: String = ""
    private var password: String = ""

    init(signUpRepository: SignUpRepositoryProtocol, loginRepository: LoginRepositoryProtocol) {
        self.signUpRepository = signUpRepository
        self.loginRepository = loginRepository
        loadKikurageStateWithUserUseCase = LoadKikurageStateWithUserUseCase(kikurageStateRepository: KikurageStateRepository(), kikurageUserRepository: KikurageUserRepository())
    }
}

// MARK: - Setting Data

extension LoginViewModel {
    private func setLoginInfo() -> (email: String, password: String) {
        (email, password)
    }

    func resetLoginInfo() {
        email = ""
        password = ""
    }

    func setEmail(_ value: String) {
        email = value
    }

    func setPassword(_ value: String) {
        password = value
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
                self?.loadKikurageStateWithUserUseCase.invoke(uid: loginUser.uid) { [weak self] responses in
                    switch responses {
                    case .success(let res):
                        self?.delegate?.loginViewModelDidSuccessLogin(self, user: res.user, state: res.state)
                    case .failure(let error):
                        self?.delegate?.loginViewModelDidFailedLogin(self, with: error.description())
                    }
                }
            case .failure(let error):
                self?.delegate?.loginViewModelDidFailedLogin(self, with: error.description())
            }
        }
    }
}
