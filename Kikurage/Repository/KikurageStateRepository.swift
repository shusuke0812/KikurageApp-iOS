//
//  KikurageStateRepository.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2020/10/15.
//  Copyright © 2020 shusuke. All rights reserved.
//

import Firebase
import FirebaseFirestoreSwift
import RxSwift

protocol KikurageStateRepositoryProtocol {
    /// KikurageStateを読み込む
    func getKikurageState(request: KikurageStateRequest, completion: @escaping (Result<KikurageState, ClientError>) -> Void)
    func getKikurageState(request: KikurageStateRequest) -> Single<KikurageState>
    /// グラフデータを読み込む
    func getKikurageStateGraph(request: KiikurageStateGraphRequest, completion: @escaping (Result<[KikurageStateGraphTuple], ClientError>) -> Void)
}

class KikurageStateRepository: KikurageStateRepositoryProtocol {
    private let firestoreClient: FirestoreClientProtocol
    private let rxFirestoreClient: RxFirestoreClientProtocol

    init(firestoreClient: FirestoreClientProtocol = FirestoreClient(), rxFirestoreClient: RxFirestoreClientProtocol = RxFirestoreClient()) {
        self.firestoreClient = firestoreClient
        self.rxFirestoreClient = rxFirestoreClient
    }
}

// MARK: - Firebase Firestore

extension KikurageStateRepository {
    func getKikurageState(request: KikurageStateRequest, completion: @escaping (Result<KikurageState, ClientError>) -> Void) {
        firestoreClient.getDocumentRequest(request) { result in
            switch result {
            case .success(let kikurageState):
                completion(.success(kikurageState))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    func getKikurageState(request: KikurageStateRequest) -> Single<KikurageState> {
        rxFirestoreClient.getDocumentRequest(request)
    }
    func getKikurageStateGraph(request: KiikurageStateGraphRequest, completion: @escaping (Result<[KikurageStateGraphTuple], ClientError>) -> Void) {
        firestoreClient.getDocumentsRequest(request) { result in
            switch result {
            case .success(let kikurageStateGraph):
                completion(.success(kikurageStateGraph))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
