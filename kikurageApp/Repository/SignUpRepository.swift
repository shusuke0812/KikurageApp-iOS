//
//  SignUpRepository.swift
//  kikurageApp
//
//  Created by Shusuke Ota on 2021/9/8.
//  Copyright © 2021 shusuke. All rights reserved.
//

import Foundation
import Firebase

protocol SignUpRepositoryProtocol {
    /// 新規ユーザー登録を行う
    func registerUser(registerInfo: (email: String, password: String), completion: @escaping (Result<User, Error>) -> Void)
}

class SignUpRepository: SignUpRepositoryProtocol {
}

// MARK: - Firebase Authentication
extension SignUpRepository {
    // TODO: メール認証機能を追加
    func registerUser(registerInfo: (email: String, password: String), completion: @escaping (Result<User, Error>) -> Void) {
        Auth.auth().createUser(withEmail: registerInfo.email, password: registerInfo.password) { authResult, error in
            if let error = error {
                completion(.failure(error))
            }
            if let user = authResult?.user {
                completion(.success(user))
            }
        }
    }
}
