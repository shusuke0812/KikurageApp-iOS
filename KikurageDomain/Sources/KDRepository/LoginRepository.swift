//
//  LoginRepository.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2021/9/12.
//  Copyright © 2021 shusuke. All rights reserved.
//

import KDEntity
import KDFirebase

public protocol LoginRepositoryProtocol {
    func login(loginInfo: (email: String, password: String), completion: @escaping (Result<LoginUser, FirebaseClientError>) -> Void)
    func signUp(registerInfo: (email: String, password: String), completion: @escaping (Result<LoginUser, FirebaseClientError>) -> Void)
    func logout(completion: @escaping (Result<Void, FirebaseClientError>) -> Void)
}

public class LoginRepository: LoginRepositoryProtocol {
    private let firebaseAuthClient: FirebaseAuthClientProtocol

    public init(firebaseAuthClient: FirebaseAuthClientProtocol = FirebaseAuthClient()) {
        self.firebaseAuthClient = firebaseAuthClient
    }
}

// MARK: - Firebase Authentication

extension LoginRepository {
    public func login(loginInfo: (email: String, password: String), completion: @escaping (Result<LoginUser, FirebaseClientError>) -> Void) {
        firebaseAuthClient.login(loginInfo: loginInfo) { result in
            switch result {
            case .success(let authDataResult):
                guard let user = authDataResult?.user else {
                    completion(.failure(.apiError(.readError)))
                    return
                }
                let loginUser = LoginUser(uid: user.uid, isEmailVerified: user.isEmailVerified)
                completion(.success(loginUser))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    public func signUp(registerInfo: (email: String, password: String), completion: @escaping (Result<LoginUser, FirebaseClientError>) -> Void) {
        firebaseAuthClient.signUp(registerInfo: registerInfo) { result in
            switch result {
            case .success(let authDataResult):
                guard let user = authDataResult?.user else {
                    completion(.failure(.apiError(.readError)))
                    return
                }
                user.sendEmailVerification { error in
                    if let error = error {
                        dump(error)
                        completion(.failure(.apiError(.createError)))
                        return
                    }
                    let loginUser = LoginUser(uid: user.uid, isEmailVerified: user.isEmailVerified)
                    // TODO: ローカルストアに保存する LoginHelper.shared.setUserInUserDefaults(user: loginUser)
                    completion(.success(loginUser))
                }
            case .failure(let error):
                completion(.failure(.apiError(.createError)))
            }
        }
    }

    public func logout(completion: @escaping (Result<Void, FirebaseClientError>) -> Void) {
        firebaseAuthClient.logout(completion: completion)
    }
}
