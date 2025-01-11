//
//  LoginViewModel.swift
//  KikurageService
//
//  Created by Shusuke Ota on 2025/1/4.
//

import Foundation
import KDEntity
import KDLoginManager
import KDRepository
import KSSLoadKikurageStateUseCase

public protocol LoginViewModelDelegate: AnyObject {
    func loginViewModelDidSuccessLogin(_ loginViewModel: LoginViewModel?, user: KikurageUser, state: KikurageState)
    func loginViewModelDidFailedLogin(_ loginViewModel: LoginViewModel?, with errorMessage: String)
}

public class LoginViewModel {
    private let loginManager: LoginManager
    private var loginRepository: LoginRepositoryProtocol
    private let loadKikurageStateWithUserUseCase: LoadKikurageStateWithUserUseCaseProtocol

    public weak var delegate: LoginViewModelDelegate?

    private var email: String = ""
    private var password: String = ""

    public init(loginRepository: LoginRepositoryProtocol) {
        loginManager = LoginManager()
        self.loginRepository = loginRepository
        loadKikurageStateWithUserUseCase = LoadKikurageStateWithUserUseCase(kikurageStateRepository: KikurageStateRepository(), kikurageUserRepository: KikurageUserRepository())
    }
}

// MARK: - Setting Data

extension LoginViewModel {
    private func setLoginInfo() -> (email: String, password: String) {
        (email, password)
    }

    public func resetLoginInputs() {
        email = ""
        password = ""
    }

    public func setEmail(_ value: String) {
        email = value
    }

    public func setPassword(_ value: String) {
        password = value
    }
    // TODO: email, password の入力バリデーション処理を追加（`VC`の登録ボタン押下時に呼ぶ）
}

// MARK: - Firebase Authentication

extension LoginViewModel {
    public func login() {
        let loginInfo = setLoginInfo()
        loginRepository.login(loginInfo: loginInfo) { [weak self] response in
            switch response {
            case .success(let loginUser):
                self?.loginManager.saveUser(loginUser: loginUser)
                self?.loadKikurageStateWithUserUseCase.invoke(uid: loginUser.uid) { [weak self] responses in
                    switch responses {
                    case .success(let res):
                        self?.delegate?.loginViewModelDidSuccessLogin(self, user: res.user, state: res.state)
                    case .failure(let error):
                        self?.delegate?.loginViewModelDidFailedLogin(self, with: "") // TODO: Error descriptionを渡す. InfrastructureにError型を定義しているので、それらをMapするError型をKDRepositoryに定義してService層へ通知する
                    }
                }
            case .failure(let error):
                self?.delegate?.loginViewModelDidFailedLogin(self, with: error.description())
            }
        }
    }
}
