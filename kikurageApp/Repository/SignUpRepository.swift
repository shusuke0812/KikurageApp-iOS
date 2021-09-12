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
    /// ユーザー情報を`UserDefaults`へ保存する
    /// - Parameter user: Firebase Auth ユーザー
    func setUserInUserDefaults(user: User, completion: @escaping (Result<Void, Error>) -> Void)
}

class SignUpRepository: SignUpRepositoryProtocol {
}

// MARK: - UserDefaults
extension SignUpRepository {
    func setUserInUserDefaults(user: User, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: user, requiringSecureCoding: false)
            UserDefaults.standard.set(data, forKey: Constants.UserDefaultsKey.firebaseUser)
            completion(.success(()))
        } catch {
            completion(.failure(error))
        }
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
            user.sendEmailVerification { error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                completion(.success(user))
            }
        }
    }
}
