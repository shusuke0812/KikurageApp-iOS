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
    /// - Parameters:
    ///   - registerInfo:（メールアドレス, パスワード）
    ///   - completion: ユーザー登録成功、失敗のハンドル
    func registerUser(registerInfo: (email: String, password: String), completion: @escaping (Result<User, Error>) -> Void)
}

class SignUpRepository: SignUpRepositoryProtocol {
}

// MARK: - UserDefaults
extension SignUpRepository {
    private func setUserInUserDefaults(user: User) {
        UserDefaults.standard.set(user, forKey: Constants.UserDefaultsKey.firebaseUser)
    }
}

// MARK: - Firebase Authentication
extension SignUpRepository {
    func registerUser(registerInfo: (email: String, password: String), completion: @escaping (Result<User, Error>) -> Void) {
        Auth.auth().createUser(withEmail: registerInfo.email, password: registerInfo.password) { authResult, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let user = authResult?.user else {
                completion(.failure(NetworkError.invalidResponse))
                return
            }
            user.sendEmailVerification { [weak self]error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                self?.setUserInUserDefaults(user: user)
                completion(.success(user))
            }
        }
    }
}