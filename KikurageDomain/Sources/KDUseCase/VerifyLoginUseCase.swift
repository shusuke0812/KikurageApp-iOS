//
//  File.swift
//  KikurageDomain
//
//  Created by Shusuke Ota on 2026/10/15.
//

import Foundation
import KDLoginManager

public enum VerifyLogin {
    case registeredProductKey(key: String, userId: String)
    case notRegisteredProductKey
    case noLogin
}

public protocol VerifyLoginUseCaseProtocol {
    func invoke(completion: @escaping UseCaseCompletion<VerifyLogin>)
}

public class VerifyLoginUseCase: VerifyLoginUseCaseProtocol {
    private let loginManager: LoginManagerProtocol
    private let loadKikurageStateWithUserUseCase: LoadKikurageStateWithUserUseCaseProtocol

    public init(
        loginManager: LoginManagerProtocol = LoginManager(),
        loadKikurageStateWithUserUseCase: LoadKikurageStateWithUserUseCaseProtocol = LoadKikurageStateWithUserUseCase()
    ) {
        self.loginManager = loginManager
        self.loadKikurageStateWithUserUseCase = loadKikurageStateWithUserUseCase
    }

    public func invoke(completion: @escaping UseCaseCompletion<VerifyLogin>) {
        guard loginManager.isLogin, let userId = loginManager.userID else {
            completion(.success(VerifyLogin.noLogin))
            return
        }
        loadKikurageStateWithUserUseCase.invoke(uid: userId) { result in
            switch result {
            case .success(let res):
                let productKey = res.user.productKey
                if productKey.isEmpty {
                    completion(.success(VerifyLogin.notRegisteredProductKey))
                    return
                }
                completion(.success(VerifyLogin.registeredProductKey(key: productKey, userId: userId)))
            case .failure(let error):
                completion(.failure("error")) // TODO: エラーメッセージ修正
            }
        }
    }
}
