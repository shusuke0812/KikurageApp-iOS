//
//  FirebaseAuthClient.swift
//  KikurageDomain
//
//  Created by Shusuke Ota on 2024/12/31.
//

import FirebaseAuth
import Foundation

public protocol FirebaseAuthClientProtocol {
    func login(loginInfo: (email: String, password: String), completion: @escaping (Result<AuthDataResult?, FirebaseClientError>) -> Void)
    func signUp(registerInfo: (email: String, password: String), completion: @escaping (Result<AuthDataResult?, FirebaseClientError>) -> Void)
}

public struct FirebaseAuthClient: FirebaseAuthClientProtocol {
    public init() {}

    public func login(loginInfo: (email: String, password: String), completion: @escaping (Result<AuthDataResult?, FirebaseClientError>) -> Void) {
        Auth.auth().signIn(withEmail: loginInfo.email, password: loginInfo.password) { authDataResult, error in
            if let error = error {
                completion(.failure(FirebaseClientError.apiError(.readError)))
                return
            }
            completion(.success(authDataResult))
        }
    }
    
    public func signUp(registerInfo: (email: String, password: String), completion: @escaping (Result<AuthDataResult?, FirebaseClientError>) -> Void) {
        Auth.auth().createUser(withEmail: registerInfo.email, password: registerInfo.password) { authDataResult, error in
            if let error = error {
                completion(.failure(FirebaseClientError.apiError(.createError)))
                return
            }
            completion(.success(authDataResult))
        }
    }
}
