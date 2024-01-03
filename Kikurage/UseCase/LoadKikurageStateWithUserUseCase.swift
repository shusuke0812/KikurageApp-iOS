//
//  LoadKikurageStateWithUserUseCase.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2024/1/3.
//  Copyright © 2024 shusuke. All rights reserved.
//

import Foundation

typealias KikurageStateUserTuple = (user: KikurageUser, state: KikurageState)

protocol LoadKikurageStateWithUserUseCaseProtocol {
    func invoke(uid: String, completion: @escaping (Result<KikurageStateUserTuple, ClientError>) -> Void)
}

class LoadKikurageStateWithUserUseCase: LoadKikurageStateWithUserUseCaseProtocol {
    private let kikurageStateRepository: KikurageStateRepositoryProtocol
    private let kikurageUserRepository: KikurageUserRepositoryProtocol

    init(kikurageStateRepository: KikurageStateRepositoryProtocol, kikurageUserRepository: KikurageUserRepositoryProtocol) {
        self.kikurageStateRepository = kikurageStateRepository
        self.kikurageUserRepository = kikurageUserRepository
    }

    func invoke(uid: String, completion: @escaping (Result<KikurageStateUserTuple, ClientError>) -> Void) {
        let userRequest = KikurageUserRequest(uid: uid)
        kikurageUserRepository.getKikurageUser(request: userRequest) { [weak self] response in
            switch response {
            case .success(let kikurageUser):
                let stateRequest = KikurageStateRequest(productID: kikurageUser.productKey)
                self?.kikurageStateRepository.getKikurageState(request: stateRequest) { response in
                    switch response {
                    case .success(let kikurageState):
                        completion(.success((kikurageUser, kikurageState)))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
