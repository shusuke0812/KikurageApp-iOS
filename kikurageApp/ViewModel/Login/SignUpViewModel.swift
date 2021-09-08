//
//  SignUpViewModel.swift
//  kikurageApp
//
//  Created by Shusuke Ota on 2021/9/6.
//  Copyright © 2021 shusuke. All rights reserved.
//

import Foundation

protocol SignUpViewModelDelegate: AnyObject {
    func didSuccessRegisterUser()
    func didFailedRegisterUser(errorMessage: String)
}

class SignUpViewModel {
    private var signUpRepository: SignUpRepositoryProtocol
    
    weak var delegate: SignUpBaseViewDelegate?
    
    init(signUpRepository: SignUpRepositoryProtocol) {
        self.signUpRepository = signUpRepository
    }
}

// MARK: - Firebase Authentication
extension SignUpViewModel {
    func registerUser(registerInfo: (email: String, password: String)) {
    }
}
