//
//  KikurageUserRepository.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2020/10/22.
//  Copyright © 2020 shusuke. All rights reserved.
//

import Firebase
import FirebaseFirestoreSwift

protocol KikurageUserRepositoryProtocol {
    /// きくらげユーザーを読み込む
    func getKikurageUser(request: KikurageUserRequest, completion: @escaping (Result<KikurageUser, ClientError>) -> Void)
    /// きくらげユーザーを登録する
    func postKikurageUser(request: KikurageUserRequest, completion: @escaping (Result<Void, ClientError>) -> Void)
}

class KikurageUserRepository: KikurageUserRepositoryProtocol {
    private let firestoreClient: FirestoreClientProtocol

    init(firestoreClient: FirestoreClientProtocol = FirestoreClient()) {
        self.firestoreClient = firestoreClient
    }
}

// MARK: - Firebase Firestore

extension KikurageUserRepository {
    func getKikurageUser(request: KikurageUserRequest, completion: @escaping (Result<KikurageUser, ClientError>) -> Void) {
        firestoreClient.getDocumentRequest(request) { result in
            switch result {
            case .success(let kikurageUser):
                completion(.success(kikurageUser))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    func postKikurageUser(request: KikurageUserRequest, completion: @escaping (Result<Void, ClientError>) -> Void) {
        firestoreClient.postDocumentRequest(request) { result in
            switch result {
            case .success():
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
