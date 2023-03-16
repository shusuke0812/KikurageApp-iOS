//
//  SignUpRepository.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2021/9/8.
//  Copyright © 2021 shusuke. All rights reserved.
//

import Firebase
import Foundation

protocol SignUpRepositoryProtocol {
    /// 新規ユーザー登録を行う
    /// - Parameters:
    ///   - registerInfo:（メールアドレス, パスワード）
    ///   - completion: ユーザー登録成功、失敗のハンドル
    func registerUser(registerInfo: (email: String, password: String), completion: @escaping (Result<LoginUser, ClientError>) -> Void)
}

class SignUpRepository: SignUpRepositoryProtocol {}

// MARK: - Firebase Authentication

extension SignUpRepository {
    func registerUser(registerInfo: (email: String, password: String), completion: @escaping (Result<LoginUser, ClientError>) -> Void) {
        Auth.auth().createUser(withEmail: registerInfo.email, password: registerInfo.password) { authResult, error in
            if let error = error {
                dump(error)
                completion(.failure(ClientError.apiError(.createError)))
                return
            }
            guard let user = authResult?.user else {
                completion(.failure(ClientError.apiError(.readError)))
                return
            }
            user.sendEmailVerification { error in
                if let error = error {
                    dump(error)
                    completion(.failure(ClientError.apiError(.createError)))
                    return
                }
                LoginHelper.shared.setUserInUserDefaults(user: user)
                let loginUser = LoginUser(uid: user.uid)
                completion(.success(loginUser))
            }
        }
    }
}
