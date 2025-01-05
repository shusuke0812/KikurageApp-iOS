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
    func logout(completion: @escaping (Result<Void, FirebaseClientError>) -> Void)
    func listenUserAttach(onUpdate: @escaping (User) -> Void)
    func listenUserDetach()
    func reloadUser(onError: ((Error?) -> Void)?)
}

public class FirebaseAuthClient: FirebaseAuthClientProtocol {
    private var userListenerHandler: AuthStateDidChangeListenerHandle?

    public init() {}
    
    deinit {
        listenUserDetach()
    }

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
    
    public func logout(completion: @escaping (Result<Void, FirebaseClientError>) -> Void) {
        do {
            try Auth.auth().signOut()
            completion(.success(()))
        } catch {
            completion(.failure(.apiError(.updateError)))
        }
    }
    
    public func listenUserAttach(onUpdate: @escaping (User) -> Void) {
        if userListenerHandler != nil {
            return
        }
        userListenerHandler = Auth.auth().addStateDidChangeListener { _, user in
            guard let user = user else {
                return
            }
            onUpdate(user)
        }
    }
    
    public func reloadUser(onError: ((Error?) -> Void)?) {
        Auth.auth().currentUser?.reload { error in
            onError?(error)
        }
    }
    
    public func listenUserDetach() {
        guard let userListenerHandler = userListenerHandler else {
            return
        }
        Auth.auth().removeStateDidChangeListener(userListenerHandler)
    }
}
