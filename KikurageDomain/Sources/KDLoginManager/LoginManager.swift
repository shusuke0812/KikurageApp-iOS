//
//  LoginManager.swift
//  KikurageDomain
//
//  Created by Shusuke Ota on 2025/1/2.
//

import KDFirebase
import KDLocalStore
import KDEntity
import Foundation

public class LoginManager {
    private let firebaseAuthClient: FirebaseAuthClientProtocol
    private let userDefaultClient: UserDefaultClientProtocol
    
    public init() {
        firebaseAuthClient = FirebaseAuthClient()
        userDefaultClient = UserDefaultClient()
    }
    
    public var userId: String? {
        if let user = user {
            return user.isEmailVerified ? user.uid : nil
        }
        return nil
    }
    
    public var isLogin: Bool {
        if let user = user {
            return user.isEmailVerified
        }
        return false
    }
    
    public func reloadUser(completion: ((Result<Void, Error>) -> Void)? = nil) {
        firebaseAuthClient.reloadUser { error in
            if let error = error {
                completion?(.failure(error))
                return
            }
            completion?(.success(()))
        }
    }
    
    public func saveUser(loginUser: LoginUser) {
        let request = LoginUserRequest(loginUser: loginUser)
        userDefaultClient.update(request) { error in
            // do nothing
        }
    }
    
    public func removeUser() {
        let request = LoginUserRequest()
        userDefaultClient.remove(request)
    }
    
    private var user: LoginUser? {
        let request = LoginUserRequest()
        let result = userDefaultClient.read(request)
        
        switch result {
        case .success(let user):
            return user
        case .failure(let error):
            return nil
        }
    }
}
