//
//  SignUpViewModel.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2021/9/6.
//  Copyright © 2021 shusuke. All rights reserved.
//

import Foundation
import KDLoginManager
import KDRepository
import KDEntity

public protocol SignUpViewModelDelegate: AnyObject {
    func signUpViewModelDidSuccessRegisterUser(_ signUpViewModel: SignUpViewModel)
    func signUpViewModelDidFailedRegisterUser(_ signUpViewModel: SignUpViewModel, with errorMessage: String)
}

public class SignUpViewModel {
    private let loginManager: LoginManager
    private var loginRepository: LoginRepositoryProtocol
    private var loginUser: LoginUser?

    public weak var delegate: SignUpViewModelDelegate?

    public var email: String = ""
    public var password: String = ""

    public init(loginRepository: LoginRepositoryProtocol) {
        self.loginManager = LoginManager()
        self.loginRepository = loginRepository
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

// MARK: - Setting Data

extension SignUpViewModel {
    private func setRegisterInfo() -> (email: String, password: String) {
        (email, password)
    }

    public func initUserInfo() {
        email = ""
        password = ""
    }
    // TODO: email, password の入力バリデーション処理を追加（`VC`の登録ボタン押下時に呼ぶ）
}

// MARK: - Firebase Authentication

extension SignUpViewModel {
    /// ユーザー登録する
    public func registerUser() {
        let registerInfo = setRegisterInfo()
        loginRepository.signUp(registerInfo: registerInfo) { [weak self] response in
            switch response {
            case .success(let loginUser):
                self?.loginUser = loginUser
                self?.delegate?.signUpViewModelDidSuccessRegisterUser(self!)
            case .failure(let error):
                self?.delegate?.signUpViewModelDidFailedRegisterUser(self!, with: error.description())
            }
        }
    }
}
