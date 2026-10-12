//
//  LoginViewState.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2025/1/24.
//

import Combine
import Foundation

class LoginViewState: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var enabled: Bool = true

    func reset() {
        email = ""
        password = ""
    }
}
