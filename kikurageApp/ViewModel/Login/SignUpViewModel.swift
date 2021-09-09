//
//  SignUpViewModel.swift
//  kikurageApp
//
//  Created by Shusuke Ota on 2021/9/6.
//  Copyright © 2021 shusuke. All rights reserved.
//

import Foundation
import Firebase

protocol SignUpViewModelDelegate: AnyObject {
    func didSuccessRegisterUser()
    func didFailedRegisterUser(errorMessage: String)
}

class SignUpViewModel {
    private var signUpRepository: SignUpRepositoryProtocol
    
    weak var delegate: SignUpViewModelDelegate?
    
    private var user: User?
    
    init(signUpRepository: SignUpRepositoryProtocol) {
        self.signUpRepository = signUpRepository
    }
}

// MARK: - Firebase Authentication
extension SignUpViewModel {
    func registerUser(registerInfo: (email: String, password: String)) {
        self.signUpRepository.registerUser(registerInfo: registerInfo) { [weak self] response in
            switch response {
            case .success(let user):
                self?.user = user
            case .failure(let error):
                print("DEBUG: \(error)")
                self?.delegate?.didFailedRegisterUser(errorMessage: "ユーザー登録に失敗しました")
            }
        }
    }
}
