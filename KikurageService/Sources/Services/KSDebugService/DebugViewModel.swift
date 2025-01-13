//
//  DebugViewModel.swift
//  KikurageService
//
//  Created by Shusuke Ota on 2022/6/6.
//  Copyright © 2022 shusuke. All rights reserved.
//

import Foundation
import KDLoginManager
import KDRepository

public protocol DebugViewModelDelegate: AnyObject {}

public class DebugViewModel {
    private let loginManager: LoginManager
    private let loginRepository: LoginRepositoryProtocol

    public weak var delegate: DebugViewModelDelegate?

    public init(loginRepository: LoginRepositoryProtocol = LoginRepository()) {
        self.loginRepository = loginRepository
        loginManager = LoginManager()
    }

    public func logout(completion: @escaping ((Result<Void, Error>) -> Void)) {
        loginRepository.logout { [weak self] result in
            switch result {
            case .success:
                self?.loginManager.removeUser()
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
