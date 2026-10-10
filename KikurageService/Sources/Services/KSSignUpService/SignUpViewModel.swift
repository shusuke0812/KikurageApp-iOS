//
//  SignUpViewModel.swift
//  KikurageService
//
//  Created by Shusuke Ota on 2021/9/6.
//  Copyright © 2021 shusuke. All rights reserved.
//

import Combine
import Foundation
import KDEntity
import KDLoginManager
import KDRepository

public protocol SignUpViewModelDelegate: AnyObject {
    func signUpViewModelDidSuccessRegisterUser(_ signUpViewModel: SignUpViewModel)
    func signUpViewModelDidFailedRegisterUser(_ signUpViewModel: SignUpViewModel, with errorMessage: String)
}

public class SignUpViewModel {
    public weak var delegate: SignUpViewModelDelegate?

    public var state: SignUpState

    private let loginManager: LoginManager
    private var loginRepository: LoginRepositoryProtocol

    private var cancellables = Set<AnyCancellable>()

    public init(loginRepository: LoginRepositoryProtocol = LoginRepository()) {
        loginManager = LoginManager()
        self.loginRepository = loginRepository
        state = SignUpState()

        state.$email.combineLatest(state.$password)
            .map { email, password in
                !(email.isEmpty || password.isEmpty)
            }
            .assign(to: &state.$enabled)
    }

    public func reloadUser(completion: @escaping ((Result<Void, Error>) -> Void)) {
        loginManager.reloadUser { [weak self] result in
            switch result {
            case .success:
                self?.loginManager.listenUserDetach()
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

// MARK: - Firebase Authentication

extension SignUpViewModel {
    public func registerUser() {
        loginRepository.signUp(registerInfo: (state.email, state.password)) { [weak self] response in
            switch response {
            case .success(let loginUser):
                self?.loginManager.saveUser(loginUser: loginUser)
                self?.delegate?.signUpViewModelDidSuccessRegisterUser(self!)
            case .failure(let error):
                self?.delegate?.signUpViewModelDidFailedRegisterUser(self!, with: error.description())
            }
        }
    }
}
