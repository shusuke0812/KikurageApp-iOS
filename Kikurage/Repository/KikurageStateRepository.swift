//
//  KikurageStateRepository.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2020/10/15.
//  Copyright © 2020 shusuke. All rights reserved.
//

import Firebase
import FirebaseFirestoreSwift
import RealmSwift
import RxSwift

protocol KikurageStateRepositoryProtocol {
    /// KikurageStateを読み込む
    func getKikurageState(request: KikurageStateRequest, completion: @escaping (Result<KikurageState, ClientError>) -> Void)
    func getKikurageState(request: KikurageStateRequest) -> Single<KikurageState>
    /// グラフデータを読み込む
    func getKikurageStateGraph(request: KiikurageStateGraphRequest, completion: @escaping (Result<[KikurageStateGraphTuple], ClientError>) -> Void)
    func putKikurageStateGraph(object: RealmSwift.Object, completion: @escaping (Result<Void, Error>) -> Void)
    func getKikurageStateGraph(productID: String, completion: @escaping (Result<RealmSwift.Object, Error>) -> Void)
}

class KikurageStateRepository: KikurageStateRepositoryProtocol {
    private let firestoreClient: FirestoreClientProtocol
    private let rxFirestoreClient: RxFirestoreClientProtocol
    private let realmClient: RealmClientProtocol

    init(firestoreClient: FirestoreClientProtocol = FirestoreClient(), rxFirestoreClient: RxFirestoreClientProtocol = RxFirestoreClient(), realmClient: RealmClientProtocol = RealmClient()) {
        self.firestoreClient = firestoreClient
        self.rxFirestoreClient = rxFirestoreClient
        self.realmClient = realmClient
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

// MARK: - Realm

extension KikurageStateRepository {
    func putKikurageStateGraph(object: RealmSwift.Object, completion: @escaping (Result<Void, Error>) -> Void) {
        realmClient.writeRequest(object) { result in
            switch result {
            case .success(let void):
                completion(.success(void))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func getKikurageStateGraph(productID: String, completion: @escaping (Result<RealmSwift.Object, Error>) -> Void) {
        realmClient.readRequest(id: productID) { result in
            switch result {
            case .success(let object):
                completion(.success(object))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
