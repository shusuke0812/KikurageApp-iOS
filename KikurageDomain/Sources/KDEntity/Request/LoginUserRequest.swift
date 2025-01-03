//
//  LoginUserRequest.swift
//  KikurageDomain
//
//  Created by Shusuke Ota on 2025/1/3.
//

import KDLocalStore
import Foundation

public struct LoginUserRequest: UserDefaultsRequestProtocol {
    public typealias Response = LoginUser
    
    public var key: String {
        "firebase_user"
    }
    public var saveData: LoginUser?
    
    public init(loginUser: LoginUser? = nil) {
        self.saveData = loginUser
    }
}
