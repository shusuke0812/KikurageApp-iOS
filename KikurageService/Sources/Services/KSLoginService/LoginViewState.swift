//
//  LoginViewState.swift
//  KikurageService
//
//  Created by Shusuke Ota on 2025/1/24.
//

import Combine
import Foundation

public class LoginViewState: ObservableObject {
    @Published public var email: String = ""
    @Published public var password: String = ""
    @Published public var enabled: Bool = true

    public init() {}

    public func reset() {
        email = ""
        password = ""
    }
}
