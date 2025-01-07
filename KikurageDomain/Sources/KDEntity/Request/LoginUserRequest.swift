//
//  LoginUserRequest.swift
//  KikurageDomain
//
//  Created by Shusuke Ota on 2025/1/3.
//

import Foundation
import KDLocalStore

public struct LoginUserRequest: UserDefaultsRequestProtocol {
    public typealias Response = LoginUser

    public var key: String {
        "firebase_user"
    }

    public var saveData: LoginUser?

    public init(loginUser: LoginUser? = nil) {
        saveData = loginUser
    }
}
