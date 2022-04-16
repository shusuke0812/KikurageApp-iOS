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
    /// - Parameters:
    ///   - productId: プロダクトキー（ドキュメントID）
    ///   - completion: 読み込み成功、失敗のハンドル
    func getKikurageState(request: KikurageStateRequest, completion: @escaping (Result<KikurageState, ClientError>) -> Void)
    func getKikurageState(request: KikurageStateRequest) -> Single<KikurageState>
    /// グラフデータを読み込む
    /// - Parameters:
    ///   - productId: プロダクトキー（ドキュメントID）
    ///   - completion: 読み込み成功、失敗のハンドル
    func getKikurageStateGraph(productId: String, completion: @escaping (Result<[KikurageStateGraphTuple], ClientError>) -> Void)
}

class KikurageStateRepository: KikurageStateRepositoryProtocol {
    private let firestoreClient: FirestoreClientProtocol
    
    init(firestoreClient: FirestoreClientProtocol = FirestoreClient()) {
        self.firestoreClient = firestoreClient
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
        return firestoreClient.getDocumentRequest(request)
    }
    func getKikurageStateGraph(productId: String, completion: @escaping (Result<[KikurageStateGraphTuple], ClientError>) -> Void) {
        let db = Firestore.firestore()
        let collectionRef: CollectionReference = db.collection(Constants.FirestoreCollectionName.states).document(productId).collection(Constants.FirestoreCollectionName.graph)

        collectionRef.getDocuments { snapshot, error in
            if let error = error {
                dump(error)
                completion(.failure(ClientError.apiError(.readError)))
                return
            }
            guard let snapshot = snapshot else {
                completion(.failure(ClientError.apiError(.readError)))
                return
            }
            var graphs: [(graph: KikurageStateGraph, documentId: String)] = []
            do {
                for document in snapshot.documents {
                    let graph = try Firestore.Decoder().decode(KikurageStateGraph.self, from: document.data())
                    graphs.append((graph: graph, documentId: document.documentID))
                }
                completion(.success(graphs))
            } catch {
                completion(.failure(ClientError.responseParseError(error)))
            }
        }
    }
}
