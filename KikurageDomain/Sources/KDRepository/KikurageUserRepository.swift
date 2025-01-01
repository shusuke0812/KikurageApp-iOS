//
//  KikurageUserRepository.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2020/10/22.
//  Copyright © 2020 shusuke. All rights reserved.
//

import KDFirebase

public protocol KikurageUserRepositoryProtocol {
    /// きくらげユーザーを読み込む
    func getKikurageUser(request: KikurageUserRequest, completion: @escaping (Result<KikurageUser, FirebaseClientError>) -> Void)
    /// きくらげユーザーを登録する
    func postKikurageUser(request: KikurageUserRequest, completion: @escaping (Result<Void, FirebaseClientError>) -> Void)
}

public class KikurageUserRepository: KikurageUserRepositoryProtocol {
    private let firestoreClient: FirestoreClientProtocol

    public init(firestoreClient: FirestoreClientProtocol = FirestoreClient()) {
        self.firestoreClient = firestoreClient
    }
}

// MARK: - Firebase Firestore

extension KikurageUserRepository {
    public func getKikurageUser(request: KikurageUserRequest, completion: @escaping (Result<KikurageUser, FirebaseClientError>) -> Void) {
        firestoreClient.getDocumentRequest(request) { result in
            switch result {
            case .success(let kikurageUser):
                completion(.success(kikurageUser))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    public func postKikurageUser(request: KikurageUserRequest, completion: @escaping (Result<Void, FirebaseClientError>) -> Void) {
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
