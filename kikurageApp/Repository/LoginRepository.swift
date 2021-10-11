//
//  LoginRepository.swift
//  kikurageApp
//
//  Created by Shusuke Ota on 2021/9/12.
//  Copyright © 2021 shusuke. All rights reserved.
//

import Foundation
import Firebase

protocol LoginRepositoryProtocol {
    func login(loginInfo: (email: String, password: String), completion: @escaping (Result<LoginUser, Error>) -> Void)
}

class LoginRepository: LoginRepositoryProtocol {
}

// MARK: - Firebase Authentication
extension LoginRepository {
    func login(loginInfo: (email: String, password: String), completion: @escaping (Result<LoginUser, Error>) -> Void) {
        Auth.auth().signIn(withEmail: loginInfo.email, password: loginInfo.password) { authResult, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let user = authResult?.user else {
                completion(.failure(NetworkError.invalidResponse))
                return
            }
            LoginHelper.shared.setUserInUserDefaults(user: user)

            let loginUser = LoginUser(uid: user.uid)
            completion(.success(loginUser))
        }
    }
}
