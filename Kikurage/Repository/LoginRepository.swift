//
//  LoginRepository.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2021/9/12.
//  Copyright © 2021 shusuke. All rights reserved.
//

import FirebaseAuth
import Foundation

protocol LoginRepositoryProtocol {
    func login(loginInfo: (email: String, password: String), completion: @escaping (Result<LoginUser, ClientError>) -> Void)
}

class LoginRepository: LoginRepositoryProtocol {}

// MARK: - Firebase Authentication

extension LoginRepository {
    func login(loginInfo: (email: String, password: String), completion: @escaping (Result<LoginUser, ClientError>) -> Void) {
        Auth.auth().signIn(withEmail: loginInfo.email, password: loginInfo.password) { authResult, error in
            if let error = error {
                dump(error)
                completion(.failure(ClientError.apiError(.readError)))
                return
            }
            guard let user = authResult?.user else {
                completion(.failure(ClientError.apiError(.readError)))
                return
            }
            let loginUser = LoginUser(uid: user.uid, isEmailVerified: user.isEmailVerified)
            LoginHelper.shared.setUserInUserDefaults(user: loginUser)
            completion(.success(loginUser))
        }
    }
}
