//
//  SignUpRepository.swift
//  kikurageApp
//
//  Created by Shusuke Ota on 2021/9/8.
//  Copyright © 2021 shusuke. All rights reserved.
//

import Foundation

protocol SignUpRepositoryProtocol {
    /// 新規ユーザー登録を行う
    func registerUser(registerInfo: (email: String, password: String), completion: @escaping (Result<, Error>) -> Void)
}

class SignUpRepository: SignUpRepositoryProtocol {
}

// MARK: - Firebase Authentication
extension SignUpRepository {
    
}
