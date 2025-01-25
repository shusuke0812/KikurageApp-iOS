//
//  SignUpState.swift
//  KikurageService
//
//  Created by Shusuke Ota on 2025/1/25.
//

import Combine
import Foundation

public class SignUpState: ObservableObject {
    @Published public var email: String = ""
    @Published public var password: String = ""
    @Published public var enabled: Bool = true

    public init() {}

    public func reset() {
        email = ""
        password = ""
    }
}
