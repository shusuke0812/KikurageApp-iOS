//
//  LoginViewModel.swift
//  KikurageService
//
//  Created by Shusuke Ota on 2025/1/4.
//

import Combine
import Foundation
import KDLoginManager
import KDRepository
import KSSLoadKikurageStateUseCase

@_exported import KDEntity

public protocol LoginViewModelDelegate: AnyObject {
    func loginViewModelDidSuccessLogin(_ loginViewModel: LoginViewModel?, user: KikurageUser, state: KikurageState)
    func loginViewModelDidFailedLogin(_ loginViewModel: LoginViewModel?, with errorMessage: String)
}

public class LoginViewModel {
    public weak var delegate: LoginViewModelDelegate?

    public var state: LoginViewState

    private let loginManager: LoginManager
    private var loginRepository: LoginRepositoryProtocol
    private let loadKikurageStateWithUserUseCase: LoadKikurageStateWithUserUseCaseProtocol

    private var cancellables = Set<AnyCancellable>()

    public init(loginRepository: LoginRepositoryProtocol = LoginRepository()) {
        loginManager = LoginManager()
        self.loginRepository = loginRepository
        loadKikurageStateWithUserUseCase = LoadKikurageStateWithUserUseCase(kikurageStateRepository: KikurageStateRepository(), kikurageUserRepository: KikurageUserRepository())
        state = LoginViewState()

        state.$email.combineLatest(state.$password)
            .map { email, password in
                !(email.isEmpty || password.isEmpty)
            }
            .assign(to: &state.$enabled)
    }
}

// MARK: - Firebase Authentication

extension LoginViewModel {
    public func login() {
        loginRepository.login(loginInfo: (state.email, state.password)) { [weak self] response in
            switch response {
            case .success(let loginUser):
                self?.loginManager.saveUser(loginUser: loginUser)
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
