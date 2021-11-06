//
//  SignUpViewModel.swift
//  kikurageApp
//
//  Created by Shusuke Ota on 2021/9/6.
//  Copyright © 2021 shusuke. All rights reserved.
//

import Foundation

protocol SignUpViewModelDelegate: AnyObject {
    /// ユーザー登録に成功した
    func didSuccessRegisterUser()
    /// ユーザー登録に失敗した
    /// - Parameter errorMessage: エラーメッセージ
    func didFailedRegisterUser(errorMessage: String)
}

class SignUpViewModel {
    private var signUpRepository: SignUpRepositoryProtocol

    weak var delegate: SignUpViewModelDelegate?

    private var loginUser: LoginUser?
    var email: String = ""
    var password: String = ""

    init(signUpRepository: SignUpRepositoryProtocol) {
        self.signUpRepository = signUpRepository
    }
}

// MARK: - Setting Data
extension SignUpViewModel {
    private func setRegisterInfo() -> (email: String, password: String) {
        (email, password)
    }
    func initUserInfo() {
        email = ""
        password = ""
    }
    // TODO: email, password の入力バリデーション処理を追加（`VC`の登録ボタン押下時に呼ぶ）
}

// MARK: - Firebase Authentication
extension SignUpViewModel {
    /// ユーザー登録する
    func registerUser() {
        let registerInfo = setRegisterInfo()
        signUpRepository.registerUser(registerInfo: registerInfo) { [weak self] response in
            switch response {
            case .success(let loginUser):
                self?.loginUser = loginUser
                self?.delegate?.didSuccessRegisterUser()
            case .failure(let error):
                self?.delegate?.didFailedRegisterUser(errorMessage: error.description())
            }
        }
    }
}
